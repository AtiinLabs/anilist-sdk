import XCTest
@testable import anilist

internal final class MediaListRequestsTests: XCTestCase {
    private var client = AniListClient()

    override internal func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        client = AniListClient(session: URLSession(configuration: configuration)) { "mock_token" }
    }

    private func respond(status: Int, body: String) {
        MockURLProtocol.requestHandler = { request in
            let url = try XCTUnwrap(request.url)
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil))
            return (response, Data(body.utf8))
        }
    }

    private func encoded<V: Encodable>(_ variables: V?) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return try XCTUnwrap(String(data: encoder.encode(variables), encoding: .utf8))
    }

    internal func testSaveMutationSendsOnlyProvidedFields() throws {
        let mutation = SaveMediaListEntryMutation(
            mediaId: 1,
            status: .completed,
            progress: 5,
            repeat: 1,
            private: false,
            completedAt: FuzzyDate(year: 2024, month: 2, day: 3)
        )

        XCTAssertEqual(
            try encoded(mutation.variables),
            #"{"completedAt":{"day":3,"month":2,"year":2024},"mediaId":1,"private":false,"progress":5,"repeat":1,"status":"COMPLETED"}"#
        )
    }

    internal func testSaveMutationReturnsSavedEntry() async throws {
        respond(status: 200, body: """
        {"data":{"SaveMediaListEntry":{"id":7,"userId":5,"mediaId":1,"status":"CURRENT","progress":4,"startedAt":{"year":2024,"month":1,"day":null}}}}
        """)

        let entry = try await client.execute(SaveMediaListEntryMutation(mediaId: 1, progress: 4)).saveMediaListEntry

        XCTAssertEqual(entry?.id, 7)
        XCTAssertEqual(entry?.status, .current)
        XCTAssertEqual(entry?.progress, 4)
        XCTAssertEqual(entry?.startedAt, FuzzyDate(year: 2024, month: 1))
    }

    internal func testMissingEntryIsNotFound() async throws {
        respond(status: 404, body: #"{"errors":[{"message":"Not Found.","status":404}],"data":{"MediaList":null}}"#)

        do {
            _ = try await client.execute(AniListQueries.MediaListEntryQuery(userName: "user", mediaId: 1))
            XCTFail("Expected a not-found error")
        } catch let error as AniListError {
            XCTAssertTrue(error.isNotFound)
        }
    }

    internal func testUnauthorizedIsNotNotFound() async throws {
        respond(status: 401, body: #"{"errors":[{"message":"Unauthorized.","status":401}],"data":{"MediaList":null}}"#)

        do {
            _ = try await client.execute(AniListQueries.MediaListEntryQuery(userName: "user", mediaId: 1))
            XCTFail("Expected an unauthorized error")
        } catch let error as AniListError {
            XCTAssertFalse(error.isNotFound)
        }
    }

    internal func testDeleteMutationDecodesResult() async throws {
        respond(status: 200, body: #"{"data":{"DeleteMediaListEntry":{"deleted":true}}}"#)

        let response = try await client.execute(DeleteMediaListEntryMutation(id: 7))

        XCTAssertEqual(response.deleteMediaListEntry?.deleted, true)
    }

    internal func testCollectionStatusFilterUsesAniListArgumentName() throws {
        let query = AniListQueries.MediaListCollectionQuery(userId: 5, type: .manga, statusIn: [.current, .repeating], chunk: 2, perChunk: 500)

        XCTAssertEqual(
            try encoded(query.variables),
            #"{"chunk":2,"perChunk":500,"status_in":["CURRENT","REPEATING"],"type":"MANGA","userId":5}"#
        )
    }
}
