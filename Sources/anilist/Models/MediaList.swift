import Foundation

public struct MediaList: Decodable, Equatable, Sendable {
    public let id: Int
    /// The owning user's id. `nil` when the query does not select `userId`.
    public let userId: Int?
    public let mediaId: Int
    public let status: MediaListStatus?
    public let score: Double?
    public let progress: Int?
    public let progressVolumes: Int?
    public let `repeat`: Int?
    public let priority: Int?
    public let `private`: Bool
    public let notes: String?
    public let hiddenFromStatusLists: Bool
    public let startedAt: FuzzyDate?
    public let completedAt: FuzzyDate?
    public let updatedAt: Int?
    public let createdAt: Int?
    public let media: Media?
    public let user: User?
    
    public enum CodingKeys: String, CodingKey {
        case id, userId, mediaId, status, score, progress, progressVolumes, `repeat`, priority, `private`, notes, hiddenFromStatusLists, startedAt, completedAt, updatedAt, createdAt, media, user
    }
    
    public init(
        id: Int,
        userId: Int? = nil,
        mediaId: Int,
        status: MediaListStatus? = nil,
        score: Double? = nil,
        progress: Int? = nil,
        progressVolumes: Int? = nil,
        `repeat`: Int? = nil,
        priority: Int? = nil,
        `private`: Bool = false,
        notes: String? = nil,
        hiddenFromStatusLists: Bool = false,
        startedAt: FuzzyDate? = nil,
        completedAt: FuzzyDate? = nil,
        updatedAt: Int? = nil,
        createdAt: Int? = nil,
        media: Media? = nil,
        user: User? = nil
    ) {
        self.id = id
        self.userId = userId
        self.mediaId = mediaId
        self.status = status
        self.score = score
        self.progress = progress
        self.progressVolumes = progressVolumes
        self.`repeat` = `repeat`
        self.priority = priority
        self.`private` = `private`
        self.notes = notes
        self.hiddenFromStatusLists = hiddenFromStatusLists
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.media = media
        self.user = user
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        self.mediaId = try container.decode(Int.self, forKey: .mediaId)
        self.status = try container.decodeLossyIfPresent(MediaListStatus.self, forKey: .status)
        self.score = try container.decodeIfPresent(Double.self, forKey: .score)
        self.progress = try container.decodeIfPresent(Int.self, forKey: .progress)
        self.progressVolumes = try container.decodeIfPresent(Int.self, forKey: .progressVolumes)
        self.`repeat` = try container.decodeIfPresent(Int.self, forKey: .`repeat`)
        self.priority = try container.decodeIfPresent(Int.self, forKey: .priority)
        self.`private` = try container.decodeIfPresent(Bool.self, forKey: .`private`) ?? false
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
        self.hiddenFromStatusLists = try container.decodeIfPresent(Bool.self, forKey: .hiddenFromStatusLists) ?? false
        self.startedAt = try container.decodeIfPresent(FuzzyDate.self, forKey: .startedAt)
        self.completedAt = try container.decodeIfPresent(FuzzyDate.self, forKey: .completedAt)
        self.updatedAt = try container.decodeIfPresent(Int.self, forKey: .updatedAt)
        self.createdAt = try container.decodeIfPresent(Int.self, forKey: .createdAt)
        self.media = try container.decodeIfPresent(Media.self, forKey: .media)
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
    }
}
