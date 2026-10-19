import Foundation

public extension AniListQueries {
    /// A query to fetch detailed information for a single Media (Anime or Manga) by its ID,
    /// including its top-rated user recommendations.
    struct MediaQuery: GraphQLRequest {
        public struct Response: Decodable, Equatable, Sendable {
            public let media: Media?
            
            public enum CodingKeys: String, CodingKey {
                case media = "Media"
            }
        }
        
        public struct Variables: Encodable, Equatable, Sendable {
            public let id: Int
            public let recommendationsPerPage: Int
            
            public init(id: Int, recommendationsPerPage: Int = 15) {
                self.id = id
                self.recommendationsPerPage = recommendationsPerPage
            }
        }
        
        public var query: String {
            """
            query ($id: Int, $recommendationsPerPage: Int) {
              Media (id: $id) {
                id
                title {
                  romaji
                  english
                  native
                  userPreferred
                }
                synonyms
                type
                format
                status
                description(asHtml: false)
                startDate {
                  year
                  month
                  day
                }
                endDate {
                  year
                  month
                  day
                }
                season
                seasonYear
                episodes
                duration
                chapters
                volumes
                countryOfOrigin
                coverImage {
                  extraLarge
                  large
                  medium
                  color
                }
                bannerImage
                genres
                averageScore
                popularity
                recommendations(sort: [RATING_DESC, ID], perPage: $recommendationsPerPage) {
                  nodes {
                    id
                    rating
                    mediaRecommendation {
                      id
                      title {
                        romaji
                        english
                        native
                        userPreferred
                      }
                      synonyms
                      type
                      format
                      status
                      coverImage {
                        extraLarge
                        large
                        medium
                        color
                      }
                      bannerImage
                      averageScore
                    }
                  }
                }
              }
            }
            """
        }
        
        public let variables: Variables?
        
        /// - Parameters:
        ///   - id: The media id.
        ///   - recommendationsPerPage: How many top-rated recommendations to include.
        public init(id: Int, recommendationsPerPage: Int = 15) {
            self.variables = Variables(id: id, recommendationsPerPage: recommendationsPerPage)
        }
    }
}
