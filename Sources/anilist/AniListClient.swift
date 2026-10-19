import Foundation

/// The main client for interacting with the AniList GraphQL API.
public struct AniListClient: Sendable {
    private let session: URLSession
    private let tokenProvider: (@Sendable () async throws -> String?)?
    private let endpoint: URL = {
        guard let url = URL(string: "https://graphql.anilist.co") else {
            fatalError("Invalid endpoint URL")
        }
        return url
    }()

    /// Initializes a new AniList API client.
    /// - Parameters:
    ///   - session: The `URLSession` to use for network requests. Defaults to `.shared`.
    ///   - tokenProvider: An optional async closure that provides a valid OAuth2 Bearer token.
    public init(session: URLSession = .shared, tokenProvider: (@Sendable () async throws -> String?)? = nil) {
        self.session = session
        self.tokenProvider = tokenProvider
    }
    
    /// Executes a GraphQL request against the AniList API.
    /// - Parameter request: The request conforming to `GraphQLRequest`.
    /// - Returns: The expected decoded response type.
    /// - Throws: `AniListError` if the request fails, hits rate limits, or returns GraphQL errors.
    public func execute<R: GraphQLRequest>(_ request: R) async throws -> R.Response {
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = try await tokenProvider?() {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let payload = RequestPayload(query: request.query, variables: request.variables)
        do {
            urlRequest.httpBody = try JSONEncoder().encode(payload)
        } catch {
            throw AniListError.decodingError("Failed to encode request payload: \(error.localizedDescription)")
        }
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as URLError {
            throw AniListError.networkError(error)
        } catch {
            throw AniListError.networkError(URLError(.unknown))
        }
        
        return try handleResponse(response, data: data)
    }

    private func handleResponse<T: Decodable>(_ response: URLResponse, data: Data) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AniListError.httpError(statusCode: 0)
        }
        
        if httpResponse.statusCode == 429 {
            var retryAfter: Int?
            if let retryStr = httpResponse.value(forHTTPHeaderField: "Retry-After") {
                retryAfter = Int(retryStr)
            }
            throw AniListError.rateLimitExceeded(retryAfter: retryAfter)
        }

        // AniList reports failures (not found, private user, unauthorized,
        // validation, API outages) as non-2xx responses with a GraphQL error body.
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errors = try? JSONDecoder().decode(ErrorsOnlyResponse.self, from: data).errors, !errors.isEmpty {
                throw AniListError.graphqlErrors(errors)
            }
            throw AniListError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let graphQLResponse: GraphQLResponse<T>
        do {
            graphQLResponse = try JSONDecoder().decode(GraphQLResponse<T>.self, from: data)
        } catch {
            throw AniListError.decodingError("Failed to decode response: \(error.localizedDescription)")
        }
        
        if let errors = graphQLResponse.errors, !errors.isEmpty {
            if graphQLResponse.data == nil {
                throw AniListError.graphqlErrors(errors)
            }
        }
        
        guard let responseData = graphQLResponse.data else {
            throw AniListError.decodingError("Response contained neither data nor errors.")
        }
        
        return responseData
    }
}

// Internal wrapper for encoding the payload
private struct RequestPayload<V: Encodable>: Encodable {
    let query: String
    let variables: V?
}

// Decodes only the `errors` array, so error bodies whose `data` shape does not
// match the request's response type still surface their messages.
private struct ErrorsOnlyResponse: Decodable {
    let errors: [GraphQLError]?
}
