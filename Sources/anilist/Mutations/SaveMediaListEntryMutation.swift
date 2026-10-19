import Foundation

/// A mutation to create or update a media list entry.
public struct SaveMediaListEntryMutation: GraphQLRequest {
    public typealias Response = SaveMediaListEntryResponse

    public var query: String {
        """
        mutation SaveMediaListEntry($id: Int, $mediaId: Int, $status: MediaListStatus, $score: Float, $scoreRaw: Int, $progress: Int) {
            SaveMediaListEntry(id: $id, mediaId: $mediaId, status: $status, score: $score, scoreRaw: $scoreRaw, progress: $progress) {
                id
                mediaId
                status
                score
                progress
            }
        }
        """
    }

    public let variables: Variables?

    public init(
        id: Int? = nil,
        mediaId: Int? = nil,
        status: MediaListStatus? = nil,
        score: Double? = nil,
        scoreRaw: Int? = nil,
        progress: Int? = nil
    ) {
        self.variables = Variables(
            id: id,
            mediaId: mediaId,
            status: status,
            score: score,
            scoreRaw: scoreRaw,
            progress: progress
        )
    }

    public struct Variables: Encodable, Sendable {
        public let id: Int?
        public let mediaId: Int?
        public let status: MediaListStatus?
        public let score: Double?
        public let scoreRaw: Int?
        public let progress: Int?
        
        public init(
            id: Int? = nil,
            mediaId: Int? = nil,
            status: MediaListStatus? = nil,
            score: Double? = nil,
            scoreRaw: Int? = nil,
            progress: Int? = nil
        ) {
            self.id = id
            self.mediaId = mediaId
            self.status = status
            self.score = score
            self.scoreRaw = scoreRaw
            self.progress = progress
        }
    }
}

public struct SaveMediaListEntryResponse: Decodable, Equatable, Sendable {
    public let saveMediaListEntry: MediaListEntry
    
    public enum CodingKeys: String, CodingKey {
        case saveMediaListEntry = "SaveMediaListEntry"
    }
}

public struct MediaListEntry: Decodable, Equatable, Sendable {
    public let id: Int
    public let mediaId: Int?
    public let status: MediaListStatus?
    public let score: Double?
    public let progress: Int?
}
