import Foundation

public extension AniListQueries {
    /// A query to search or browse Media with pagination and filters.
    /// Filters left `nil` (or empty) are not sent.
    struct SearchQuery: GraphQLRequest {
        public struct Response: Decodable, Equatable, Sendable {
            public let page: PageData?
            
            public enum CodingKeys: String, CodingKey {
                case page = "Page"
            }
            
            public struct PageData: Decodable, Equatable, Sendable {
                public let pageInfo: PageInfo?
                public let media: [Media]?
            }
        }
        
        public struct Variables: Encodable, Equatable, Sendable {
            public let page: Int?
            public let perPage: Int?
            public let search: String?
            public let type: MediaType?
            public let sort: [MediaSort]?
            public let season: MediaSeason?
            public let seasonYear: Int?
            public let genreIn: [String]?
            public let genreNotIn: [String]?
            public let tagIn: [String]?
            public let tagNotIn: [String]?
            public let formatIn: [MediaFormat]?
            public let status: MediaStatus?
            public let countryOfOrigin: String?
            // swiftlint:disable:next discouraged_optional_boolean
            public let onList: Bool?
            public let isAdult: Bool
            
            public enum CodingKeys: String, CodingKey {
                case page
                case perPage
                case search
                case type
                case sort
                case season
                case seasonYear
                case genreIn = "genre_in"
                case genreNotIn = "genre_not_in"
                case tagIn = "tag_in"
                case tagNotIn = "tag_not_in"
                case formatIn = "format_in"
                case status
                case countryOfOrigin
                case onList
                case isAdult
            }
            
            public init(
                page: Int? = 1,
                perPage: Int? = 20,
                search: String? = nil,
                type: MediaType? = nil,
                sort: [MediaSort]? = nil,
                season: MediaSeason? = nil,
                seasonYear: Int? = nil,
                genreIn: [String]? = nil,
                genreNotIn: [String]? = nil,
                tagIn: [String]? = nil,
                tagNotIn: [String]? = nil,
                formatIn: [MediaFormat]? = nil,
                status: MediaStatus? = nil,
                countryOfOrigin: String? = nil,
                // swiftlint:disable:next discouraged_optional_boolean
                onList: Bool? = nil,
                isAdult: Bool = false
            ) {
                self.page = page
                self.perPage = perPage
                self.search = search
                self.type = type
                self.sort = sort
                self.season = season
                self.seasonYear = seasonYear
                self.genreIn = genreIn.nonEmpty
                self.genreNotIn = genreNotIn.nonEmpty
                self.tagIn = tagIn.nonEmpty
                self.tagNotIn = tagNotIn.nonEmpty
                self.formatIn = formatIn.nonEmpty
                self.status = status
                self.countryOfOrigin = countryOfOrigin
                self.onList = onList
                self.isAdult = isAdult
            }
        }
        
        public var query: String {
            """
            query (
              $page: Int,
              $perPage: Int,
              $search: String,
              $type: MediaType,
              $sort: [MediaSort],
              $season: MediaSeason,
              $seasonYear: Int,
              $genre_in: [String],
              $genre_not_in: [String],
              $tag_in: [String],
              $tag_not_in: [String],
              $format_in: [MediaFormat],
              $status: MediaStatus,
              $countryOfOrigin: CountryCode,
              $onList: Boolean,
              $isAdult: Boolean
            ) {
              Page(page: $page, perPage: $perPage) {
                pageInfo {
                  total
                  perPage
                  currentPage
                  lastPage
                  hasNextPage
                }
                media(
                  search: $search,
                  type: $type,
                  sort: $sort,
                  season: $season,
                  seasonYear: $seasonYear,
                  genre_in: $genre_in,
                  genre_not_in: $genre_not_in,
                  tag_in: $tag_in,
                  tag_not_in: $tag_not_in,
                  format_in: $format_in,
                  status: $status,
                  countryOfOrigin: $countryOfOrigin,
                  onList: $onList,
                  isAdult: $isAdult
                ) {
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
                  season
                  seasonYear
                  episodes
                  chapters
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
                }
              }
            }
            """
        }
        
        public let variables: Variables?
        
        /// - Parameters:
        ///   - page: The 1-based page.
        ///   - perPage: Results per page (AniList allows up to 50).
        ///   - search: Search text.
        ///   - type: Anime or manga.
        ///   - sort: Sort order.
        ///   - season: Release season.
        ///   - seasonYear: Release season year.
        ///   - genreIn: Only media with any of these genres.
        ///   - genreNotIn: Exclude media with these genres.
        ///   - tagIn: Only media with any of these tags.
        ///   - tagNotIn: Exclude media with these tags.
        ///   - formatIn: Only media in these formats.
        ///   - status: Release status.
        ///   - countryOfOrigin: ISO 3166-1 alpha-2 country code.
        ///   - onList: With an authenticated client, only media on (true) or off (false) the viewer's lists.
        ///   - isAdult: Whether to return adult media instead of non-adult media.
        public init(
            page: Int? = 1,
            perPage: Int? = 20,
            search: String? = nil,
            type: MediaType? = nil,
            sort: [MediaSort]? = nil,
            season: MediaSeason? = nil,
            seasonYear: Int? = nil,
            genreIn: [String]? = nil,
            genreNotIn: [String]? = nil,
            tagIn: [String]? = nil,
            tagNotIn: [String]? = nil,
            formatIn: [MediaFormat]? = nil,
            status: MediaStatus? = nil,
            countryOfOrigin: String? = nil,
            // swiftlint:disable:next discouraged_optional_boolean
            onList: Bool? = nil,
            isAdult: Bool = false
        ) {
            self.variables = Variables(
                page: page,
                perPage: perPage,
                search: search,
                type: type,
                sort: sort,
                season: season,
                seasonYear: seasonYear,
                genreIn: genreIn,
                genreNotIn: genreNotIn,
                tagIn: tagIn,
                tagNotIn: tagNotIn,
                formatIn: formatIn,
                status: status,
                countryOfOrigin: countryOfOrigin,
                onList: onList,
                isAdult: isAdult
            )
        }
    }
}

private extension Optional where Wrapped: Collection {
    /// `nil` for an empty collection, so empty filters are not sent.
    var nonEmpty: Wrapped? {
        guard let collection = self, !collection.isEmpty else {
            return nil
        }
        return collection
    }
}
