import Foundation

/// A mutation to create or update a media list entry.
///
/// Pass `id` to update an existing entry or `mediaId` to create or update the
/// viewer's entry for that media. Fields left `nil` are not sent and keep their
/// current values. Requires an authenticated client.
public struct SaveMediaListEntryMutation: GraphQLRequest {
    /// The saved entry.
    public struct Response: Decodable, Equatable, Sendable {
        /// The entry as stored after the mutation.
        public let saveMediaListEntry: MediaList?

        public enum CodingKeys: String, CodingKey {
            case saveMediaListEntry = "SaveMediaListEntry"
        }
    }

    /// The entry fields to write.
    public struct Variables: Encodable, Equatable, Sendable {
        public let id: Int?
        public let mediaId: Int?
        public let status: MediaListStatus?
        public let score: Double?
        public let scoreRaw: Int?
        public let progress: Int?
        public let progressVolumes: Int?
        public let `repeat`: Int?
        public let priority: Int?
        // swiftlint:disable:next discouraged_optional_boolean
        public let `private`: Bool?
        public let notes: String?
        // swiftlint:disable:next discouraged_optional_boolean
        public let hiddenFromStatusLists: Bool?
        public let customLists: [String]?
        public let startedAt: FuzzyDate?
        public let completedAt: FuzzyDate?
    }

    public var query: String {
        """
        mutation (
          $id: Int,
          $mediaId: Int,
          $status: MediaListStatus,
          $score: Float,
          $scoreRaw: Int,
          $progress: Int,
          $progressVolumes: Int,
          $repeat: Int,
          $priority: Int,
          $private: Boolean,
          $notes: String,
          $hiddenFromStatusLists: Boolean,
          $customLists: [String],
          $startedAt: FuzzyDateInput,
          $completedAt: FuzzyDateInput
        ) {
          SaveMediaListEntry(
            id: $id,
            mediaId: $mediaId,
            status: $status,
            score: $score,
            scoreRaw: $scoreRaw,
            progress: $progress,
            progressVolumes: $progressVolumes,
            repeat: $repeat,
            priority: $priority,
            private: $private,
            notes: $notes,
            hiddenFromStatusLists: $hiddenFromStatusLists,
            customLists: $customLists,
            startedAt: $startedAt,
            completedAt: $completedAt
          ) {
            \(Selections.mediaListEntry)
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
        progress: Int? = nil,
        progressVolumes: Int? = nil,
        `repeat`: Int? = nil,
        priority: Int? = nil,
        // swiftlint:disable:next discouraged_optional_boolean
        `private`: Bool? = nil,
        notes: String? = nil,
        // swiftlint:disable:next discouraged_optional_boolean
        hiddenFromStatusLists: Bool? = nil,
        customLists: [String]? = nil,
        startedAt: FuzzyDate? = nil,
        completedAt: FuzzyDate? = nil
    ) {
        self.variables = Variables(
            id: id,
            mediaId: mediaId,
            status: status,
            score: score,
            scoreRaw: scoreRaw,
            progress: progress,
            progressVolumes: progressVolumes,
            repeat: `repeat`,
            priority: priority,
            private: `private`,
            notes: notes,
            hiddenFromStatusLists: hiddenFromStatusLists,
            customLists: customLists,
            startedAt: startedAt,
            completedAt: completedAt
        )
    }
}
