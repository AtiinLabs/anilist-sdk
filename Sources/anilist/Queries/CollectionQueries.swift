import Foundation

public extension AniListQueries {
    /// A query to fetch every genre name AniList uses.
    struct GenreCollectionQuery: GraphQLRequest {
        /// The genre names.
        public struct Response: Decodable, Equatable, Sendable {
            public let genreCollection: [String]?

            public enum CodingKeys: String, CodingKey {
                case genreCollection = "GenreCollection"
            }
        }

        public var query: String {
            """
            query {
              GenreCollection
            }
            """
        }

        public init() {}
    }

    /// A query to fetch every media tag.
    struct MediaTagCollectionQuery: GraphQLRequest {
        /// The tags.
        public struct Response: Decodable, Equatable, Sendable {
            public let mediaTagCollection: [MediaTag]?

            public enum CodingKeys: String, CodingKey {
                case mediaTagCollection = "MediaTagCollection"
            }
        }

        public var query: String {
            """
            query {
              MediaTagCollection {
                id
                name
                description
                category
                isGeneralSpoiler
                isAdult
              }
            }
            """
        }

        public init() {}
    }
}
