import Foundation

public struct Media: Codable, Equatable, Sendable {
    public let id: Int
    public let title: MediaTitle?
    public let type: MediaType?
    public let format: MediaFormat?
    public let status: MediaStatus?
    public let description: String?
    public let startDate: FuzzyDate?
    public let endDate: FuzzyDate?
    public let season: MediaSeason?
    public let seasonYear: Int?
    public let episodes: Int?
    public let duration: Int?
    public let chapters: Int?
    public let volumes: Int?
    public let coverImage: MediaCoverImage?
    public let bannerImage: String?
    public let genres: [String]?
    public let averageScore: Int?
    public let popularity: Int?
    
    public init(id: Int, title: MediaTitle? = nil, type: MediaType? = nil, format: MediaFormat? = nil, status: MediaStatus? = nil, description: String? = nil, startDate: FuzzyDate? = nil, endDate: FuzzyDate? = nil, season: MediaSeason? = nil, seasonYear: Int? = nil, episodes: Int? = nil, duration: Int? = nil, chapters: Int? = nil, volumes: Int? = nil, coverImage: MediaCoverImage? = nil, bannerImage: String? = nil, genres: [String]? = nil, averageScore: Int? = nil, popularity: Int? = nil) {
        self.id = id
        self.title = title
        self.type = type
        self.format = format
        self.status = status
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.season = season
        self.seasonYear = seasonYear
        self.episodes = episodes
        self.duration = duration
        self.chapters = chapters
        self.volumes = volumes
        self.coverImage = coverImage
        self.bannerImage = bannerImage
        self.genres = genres
        self.averageScore = averageScore
        self.popularity = popularity
    }

    public enum CodingKeys: String, CodingKey {
        case id, title, type, format, status, description, startDate, endDate, season, seasonYear, episodes, duration, chapters, volumes, coverImage, bannerImage, genres, averageScore, popularity
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(MediaTitle.self, forKey: .title)
        self.type = try container.decodeLossyIfPresent(MediaType.self, forKey: .type)
        self.format = try container.decodeLossyIfPresent(MediaFormat.self, forKey: .format)
        self.status = try container.decodeLossyIfPresent(MediaStatus.self, forKey: .status)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.startDate = try container.decodeIfPresent(FuzzyDate.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(FuzzyDate.self, forKey: .endDate)
        self.season = try container.decodeLossyIfPresent(MediaSeason.self, forKey: .season)
        self.seasonYear = try container.decodeIfPresent(Int.self, forKey: .seasonYear)
        self.episodes = try container.decodeIfPresent(Int.self, forKey: .episodes)
        self.duration = try container.decodeIfPresent(Int.self, forKey: .duration)
        self.chapters = try container.decodeIfPresent(Int.self, forKey: .chapters)
        self.volumes = try container.decodeIfPresent(Int.self, forKey: .volumes)
        self.coverImage = try container.decodeIfPresent(MediaCoverImage.self, forKey: .coverImage)
        self.bannerImage = try container.decodeIfPresent(String.self, forKey: .bannerImage)
        self.genres = try container.decodeIfPresent([String].self, forKey: .genres)
        self.averageScore = try container.decodeIfPresent(Int.self, forKey: .averageScore)
        self.popularity = try container.decodeIfPresent(Int.self, forKey: .popularity)
    }
}

public struct MediaTitle: Codable, Equatable, Sendable {
    public let romaji: String?
    public let english: String?
    public let native: String?
    public let userPreferred: String?
    
    public init(romaji: String? = nil, english: String? = nil, native: String? = nil, userPreferred: String? = nil) {
        self.romaji = romaji
        self.english = english
        self.native = native
        self.userPreferred = userPreferred
    }
}

public struct MediaCoverImage: Codable, Equatable, Sendable {
    public let extraLarge: String?
    public let large: String?
    public let medium: String?
    public let color: String?
    
    public init(extraLarge: String? = nil, large: String? = nil, medium: String? = nil, color: String? = nil) {
        self.extraLarge = extraLarge
        self.large = large
        self.medium = medium
        self.color = color
    }
}
