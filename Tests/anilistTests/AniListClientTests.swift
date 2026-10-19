import XCTest
@testable import anilist

internal final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) internal static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override internal static func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override internal static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override internal func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override internal func stopLoading() {}
}

internal final class AniListClientTests: XCTestCase {
    internal var session: URLSession!
    internal var client: AniListClient!
    
    override internal func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        client = AniListClient(session: session) { "mock_token" }
    }
    
    internal func testExecute_Success() async throws {
        let jsonResponse = """
        {
            "data": {
                "Viewer": {
                    "id": 123,
                    "name": "TestUser"
                }
            }
        }
        """
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://graphql.anilist.co")
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer mock_token")
            
            let url = try XCTUnwrap(request.url)
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
            let data = try XCTUnwrap(jsonResponse.data(using: .utf8))
            return (response, data)
        }
        
        let query = AniListQueries.ViewerQuery()
        let result = try await client.execute(query)
        
        XCTAssertEqual(result.viewer?.id, 123)
        XCTAssertEqual(result.viewer?.name, "TestUser")
    }
    
    internal func testExecute_RateLimit() async throws {
        MockURLProtocol.requestHandler = { request in
            let url = try XCTUnwrap(request.url)
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 429, httpVersion: nil, headerFields: ["Retry-After": "60"]))
            return (response, Data())
        }
        
        let query = AniListQueries.ViewerQuery()
        
        do {
            _ = try await client.execute(query)
            XCTFail("Expected rateLimitExceeded error")
        } catch AniListError.rateLimitExceeded(let retryAfter) {
            XCTAssertEqual(retryAfter, 60)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    internal func testExecute_GraphQLError() async throws {
        let jsonResponse = """
        {
            "errors": [
                {
                    "message": "User not found",
                    "status": 404
                }
            ]
        }
        """
        
        MockURLProtocol.requestHandler = { request in
            let url = try XCTUnwrap(request.url)
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
            let data = try XCTUnwrap(jsonResponse.data(using: .utf8))
            return (response, data)
        }
        
        let query = AniListQueries.ViewerQuery()
        
        do {
            _ = try await client.execute(query)
            XCTFail("Expected graphqlErrors")
        } catch AniListError.graphqlErrors(let errors) {
            XCTAssertEqual(errors.count, 1)
            XCTAssertEqual(errors.first?.message, "User not found")
            XCTAssertEqual(errors.first?.status, 404)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    internal func testExecute_PartialError() async throws {
        let jsonResponse = """
        {
            "data": {
                "Viewer": {
                    "id": 123,
                    "name": "TestUser"
                }
            },
            "errors": [
                {
                    "message": "Some field was null but required"
                }
            ]
        }
        """
        
        MockURLProtocol.requestHandler = { request in
            let url = try XCTUnwrap(request.url)
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
            let data = try XCTUnwrap(jsonResponse.data(using: .utf8))
            return (response, data)
        }
        
        let query = AniListQueries.ViewerQuery()
        let result = try await client.execute(query)
        
        // Even with partial errors, if data is present, the library should return data
        XCTAssertEqual(result.viewer?.id, 123)
        XCTAssertEqual(result.viewer?.name, "TestUser")
    }

    internal func testExecute_NotFoundStatusSurfacesGraphQLErrors() async throws {
        let jsonResponse = """
        {"errors":[{"message":"Not Found.","status":404}],"data":{"Viewer":null}}
        """

        MockURLProtocol.requestHandler = { request in
            let url = try XCTUnwrap(request.url)
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil))
            let data = try XCTUnwrap(jsonResponse.data(using: .utf8))
            return (response, data)
        }

        do {
            _ = try await client.execute(AniListQueries.ViewerQuery())
            XCTFail("Expected graphqlErrors")
        } catch let error as AniListError {
            XCTAssertEqual(error, .graphqlErrors([GraphQLError(message: "Not Found.", status: 404)]))
            XCTAssertEqual(error.localizedDescription, "Not Found.")
        }
    }

    internal func testExecute_ServerErrorWithoutGraphQLBodyThrowsHTTPError() async throws {
        MockURLProtocol.requestHandler = { request in
            let url = try XCTUnwrap(request.url)
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 502, httpVersion: nil, headerFields: nil))
            return (response, Data("<html>Bad Gateway</html>".utf8))
        }

        do {
            _ = try await client.execute(AniListQueries.ViewerQuery())
            XCTFail("Expected httpError")
        } catch let error as AniListError {
            XCTAssertEqual(error, .httpError(statusCode: 502))
        }
    }
}
