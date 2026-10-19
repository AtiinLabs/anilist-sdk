import Foundation

public extension AniListQueries {
    /// A query to fetch one media list entry, by entry id or by user and media.
    ///
    /// AniList answers with a 404 when the user has no entry for the media, so the
    /// client throws `AniListError.graphqlErrors`; check `AniListError.isNotFound`.
    struct MediaListEntryQuery: GraphQLRequest {
        /// The matching entry.
        public struct Response: Decodable, Equatable, Sendable {
            /// The entry, or `nil` if the server returned none.
            public let mediaList: MediaList?

            public enum CodingKeys: String, CodingKey {
                case mediaList = "MediaList"
            }
        }

        /// Entry lookup arguments.
        public struct Variables: Encodable, Equatable, Sendable {
            public let id: Int?
            public let userId: Int?
            public let userName: String?
            public let mediaId: Int?
        }

        public var query: String {
            """
            query ($id: Int, $userId: Int, $userName: String, $mediaId: Int) {
              MediaList(id: $id, userId: $userId, userName: $userName, mediaId: $mediaId) {
                \(Selections.mediaListEntry)
              }
            }
            """
        }

        public let variables: Variables?

        /// - Parameters:
        ///   - id: The list entry id.
        ///   - userId: The owning user's id.
        ///   - userName: The owning user's name.
        ///   - mediaId: The media id.
        public init(id: Int? = nil, userId: Int? = nil, userName: String? = nil, mediaId: Int? = nil) {
            self.variables = Variables(id: id, userId: userId, userName: userName, mediaId: mediaId)
        }
    }
}
