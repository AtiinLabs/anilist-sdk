import Foundation

/// Errors that can occur when interacting with the AniList API.
public enum AniListError: Error, Equatable, Sendable {
    /// A generic network error occurred (e.g., no internet connection).
    case networkError(URLError)
    
    /// The server returned an HTTP error code (e.g., 500 Internal Server Error).
    case httpError(statusCode: Int)
    
    /// The rate limit was exceeded. The `retryAfter` value contains the number of seconds to wait, if provided.
    case rateLimitExceeded(retryAfter: Int?)
    
    /// The server returned specific GraphQL errors.
    case graphqlErrors([GraphQLError])
    
    /// The response could not be decoded.
    case decodingError(String)
    
    public static func == (lhs: AniListError, rhs: AniListError) -> Bool {
        switch (lhs, rhs) {
        case let (.networkError(lhsValue), .networkError(rhsValue)):
            return lhsValue.code == rhsValue.code
            
        case let (.httpError(lhsValue), .httpError(rhsValue)):
            return lhsValue == rhsValue
            
        case let (.rateLimitExceeded(lhsValue), .rateLimitExceeded(rhsValue)):
            return lhsValue == rhsValue
            
        case let (.graphqlErrors(lhsValue), .graphqlErrors(rhsValue)):
            return lhsValue == rhsValue
            
        case let (.decodingError(lhsValue), .decodingError(rhsValue)):
            return lhsValue == rhsValue
            
        default:
            return false
        }
    }
}

extension AniListError: LocalizedError {
    /// A readable description; GraphQL errors use the server's messages.
    public var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.localizedDescription

        case .httpError(let statusCode):
            return "AniList returned HTTP \(statusCode)."

        case .rateLimitExceeded(let retryAfter):
            if let retryAfter {
                return "AniList rate limit exceeded. Retry after \(retryAfter) seconds."
            }
            return "AniList rate limit exceeded."

        case .graphqlErrors(let errors):
            return errors.map(\.message).joined(separator: "\n")

        case .decodingError(let message):
            return message
        }
    }
}

public extension AniListError {
    /// Whether AniList answered 404: the media, list entry or user does not exist,
    /// or the user's lists are private.
    var isNotFound: Bool {
        switch self {
        case .graphqlErrors(let errors):
            return errors.contains { $0.status == 404 }

        case .httpError(let statusCode):
            return statusCode == 404

        default:
            return false
        }
    }
}
