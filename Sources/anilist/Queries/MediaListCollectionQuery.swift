import Foundation

public extension AniListQueries {
    /// A query to fetch a user's lists. AniList splits large lists into chunks:
    /// set `perChunk` and request `chunk` 1, 2, … while `hasNextChunk` is true.
    struct MediaListCollectionQuery: GraphQLRequest {
        public struct Response: Decodable, Equatable, Sendable {
            public let mediaListCollection: MediaListCollection?
            
            public enum CodingKeys: String, CodingKey {
                case mediaListCollection = "MediaListCollection"
            }
        }
        
        public struct Variables: Encodable, Equatable, Sendable {
            public let userId: Int?
            public let userName: String?
            public let type: MediaType?
            public let statusIn: [MediaListStatus]?
            // swiftlint:disable:next discouraged_optional_boolean
            public let forceSingleCompletedList: Bool?
            public let chunk: Int?
            public let perChunk: Int?

            public enum CodingKeys: String, CodingKey {
                case userId, userName, type
                case statusIn = "status_in"
                case forceSingleCompletedList, chunk, perChunk
            }
            
            public init(
                userId: Int? = nil,
                userName: String? = nil,
                type: MediaType? = nil,
                statusIn: [MediaListStatus]? = nil,
                // swiftlint:disable:next discouraged_optional_boolean
                forceSingleCompletedList: Bool? = nil,
                chunk: Int? = nil,
                perChunk: Int? = nil
            ) {
                self.userId = userId
                self.userName = userName
                self.type = type
                self.statusIn = statusIn
                self.forceSingleCompletedList = forceSingleCompletedList
                self.chunk = chunk
                self.perChunk = perChunk
            }
        }
        
        public var query: String {
            """
            query (
              $userId: Int,
              $userName: String,
              $type: MediaType,
              $status_in: [MediaListStatus],
              $forceSingleCompletedList: Boolean,
              $chunk: Int,
              $perChunk: Int
            ) {
              MediaListCollection(
                userId: $userId,
                userName: $userName,
                type: $type,
                status_in: $status_in,
                forceSingleCompletedList: $forceSingleCompletedList,
                chunk: $chunk,
                perChunk: $perChunk
              ) {
                lists {
                  name
                  isCustomList
                  isSplitCompletedList
                  status
                  entries {
                    \(Selections.mediaListEntry)
                    media {
                      id
                      title {
                        romaji
                        english
                        native
                        userPreferred
                      }
                      type
                      format
                      status
                      episodes
                      chapters
                      volumes
                      coverImage {
                        extraLarge
                        large
                        medium
                        color
                      }
                    }
                  }
                }
                user {
                  id
                  name
                }
                hasNextChunk
              }
            }
            """
        }
        
        public let variables: Variables?
        
        /// - Parameters:
        ///   - userId: The user's id. Pass this or `userName`.
        ///   - userName: The user's name.
        ///   - type: Anime or manga lists.
        ///   - statusIn: Only entries with these statuses.
        ///   - forceSingleCompletedList: Merge split completed lists into one.
        ///   - chunk: The 1-based chunk to fetch.
        ///   - perChunk: Entries per chunk (AniList allows up to 500).
        public init(
            userId: Int? = nil,
            userName: String? = nil,
            type: MediaType? = nil,
            statusIn: [MediaListStatus]? = nil,
            // swiftlint:disable:next discouraged_optional_boolean
            forceSingleCompletedList: Bool? = nil,
            chunk: Int? = nil,
            perChunk: Int? = nil
        ) {
            self.variables = Variables(
                userId: userId,
                userName: userName,
                type: type,
                statusIn: statusIn,
                forceSingleCompletedList: forceSingleCompletedList,
                chunk: chunk,
                perChunk: perChunk
            )
        }
    }
}
