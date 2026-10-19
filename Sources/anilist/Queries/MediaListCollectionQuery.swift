import Foundation

public extension AniListQueries {
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
            
            public init(
                userId: Int? = nil,
                userName: String? = nil,
                type: MediaType? = nil
            ) {
                self.userId = userId
                self.userName = userName
                self.type = type
            }
        }
        
        public var query: String {
            """
            query ($userId: Int, $userName: String, $type: MediaType) {
              MediaListCollection (userId: $userId, userName: $userName, type: $type) {
                lists {
                  name
                  isCustomList
                  isSplitCompletedList
                  status
                  entries {
                    id
                    userId
                    mediaId
                    status
                    score
                    progress
                    progressVolumes
                    repeat
                    priority
                    private
                    notes
                    hiddenFromStatusLists
                    startedAt {
                      year
                      month
                      day
                    }
                    completedAt {
                      year
                      month
                      day
                    }
                    updatedAt
                    createdAt
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
        
        public init(
            userId: Int? = nil,
            userName: String? = nil,
            type: MediaType? = nil
        ) {
            self.variables = Variables(userId: userId, userName: userName, type: type)
        }
    }
}
