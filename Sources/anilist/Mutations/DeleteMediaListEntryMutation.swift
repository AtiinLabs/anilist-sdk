import Foundation

/// A mutation to delete a media list entry by its entry id (`MediaList.id`, not the media id).
/// Requires an authenticated client that owns the entry.
public struct DeleteMediaListEntryMutation: GraphQLRequest {
    /// The deletion result.
    public struct Response: Decodable, Equatable, Sendable {
        /// The deletion result, or `nil` if the server returned none.
        public let deleteMediaListEntry: Deleted?

        public enum CodingKeys: String, CodingKey {
            case deleteMediaListEntry = "DeleteMediaListEntry"
        }
    }

    /// The entry to delete.
    public struct Variables: Encodable, Equatable, Sendable {
        public let id: Int
    }

    public var query: String {
        """
        mutation ($id: Int) {
          DeleteMediaListEntry(id: $id) {
            deleted
          }
        }
        """
    }

    public let variables: Variables?

    /// - Parameter id: The list entry id.
    public init(id: Int) {
        self.variables = Variables(id: id)
    }
}

/// The result of a delete mutation.
public struct Deleted: Decodable, Equatable, Sendable {
    /// Whether the server deleted the item.
    public let deleted: Bool

    public enum CodingKeys: String, CodingKey {
        case deleted
    }

    public init(deleted: Bool) {
        self.deleted = deleted
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deleted = try container.decodeIfPresent(Bool.self, forKey: .deleted) ?? false
    }
}
