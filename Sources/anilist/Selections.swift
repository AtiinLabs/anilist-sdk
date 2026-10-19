import Foundation

/// GraphQL field selections shared by several requests.
internal enum Selections {
    /// Every scalar `MediaList` field decoded by `MediaList`.
    internal static let mediaListEntry = """
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
    startedAt { year month day }
    completedAt { year month day }
    updatedAt
    createdAt
    """
}
