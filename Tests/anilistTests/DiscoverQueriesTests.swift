import XCTest
@testable import anilist

internal final class DiscoverQueriesTests: XCTestCase {
    internal func testSearchFiltersUseAniListArgumentNamesAndSkipEmptyLists() throws {
        let query = AniListQueries.SearchQuery(
            page: 2,
            perPage: 30,
            type: .manga,
            sort: [.trendingDesc],
            season: .fall,
            seasonYear: 2024,
            genreIn: ["Action"],
            genreNotIn: [],
            tagIn: ["Isekai"],
            tagNotIn: ["Gore"],
            formatIn: [.oneShot],
            status: .releasing,
            countryOfOrigin: "KR",
            onList: true
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let json = try XCTUnwrap(String(data: encoder.encode(query.variables), encoding: .utf8))

        XCTAssertEqual(
            json,
            #"{"countryOfOrigin":"KR","format_in":["ONE_SHOT"],"genre_in":["Action"],"isAdult":false,"onList":true,"page":2,"perPage":30,"season":"FALL","seasonYear":2024,"sort":["TRENDING_DESC"],"status":"RELEASING","tag_in":["Isekai"],"tag_not_in":["Gore"],"type":"MANGA"}"#
        )
    }

    internal func testMediaDecodesRecommendations() throws {
        let json = """
        {
            "Media": {
                "id": 1,
                "synonyms": ["CB"],
                "countryOfOrigin": "JP",
                "recommendations": {
                    "nodes": [
                        {"id": 9, "rating": 120, "mediaRecommendation": {"id": 2, "title": {"romaji": "Trigun"}, "format": "TV"}},
                        {"id": 10, "rating": 3, "mediaRecommendation": null}
                    ]
                }
            }
        }
        """

        let response = try JSONDecoder().decode(AniListQueries.MediaQuery.Response.self, from: Data(json.utf8))
        let media = try XCTUnwrap(response.media)
        let nodes = try XCTUnwrap(media.recommendations?.nodes)

        XCTAssertEqual(media.synonyms, ["CB"])
        XCTAssertEqual(media.countryOfOrigin, "JP")
        XCTAssertEqual(nodes.count, 2)
        XCTAssertEqual(nodes.first?.mediaRecommendation?.title?.romaji, "Trigun")
        XCTAssertEqual(nodes.first?.mediaRecommendation?.format, .tvSeries)
        XCTAssertNil(nodes.last?.mediaRecommendation)
    }

    internal func testTagCollectionDefaultsMissingFlagsToFalse() throws {
        let json = #"{"MediaTagCollection":[{"id":1,"name":"Isekai","category":"Setting-Universe","isAdult":false},{"id":2,"name":"Nudity","isAdult":true,"isGeneralSpoiler":true}]}"#

        let tags = try XCTUnwrap(JSONDecoder().decode(AniListQueries.MediaTagCollectionQuery.Response.self, from: Data(json.utf8)).mediaTagCollection)

        XCTAssertEqual(tags, [
            MediaTag(id: 1, name: "Isekai", category: "Setting-Universe"),
            MediaTag(id: 2, name: "Nudity", isGeneralSpoiler: true, isAdult: true)
        ])
    }
}
