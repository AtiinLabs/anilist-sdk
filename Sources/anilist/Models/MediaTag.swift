import Foundation

/// A tag describing media themes or elements.
public struct MediaTag: Decodable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let description: String?
    public let category: String?
    public let isGeneralSpoiler: Bool
    public let isAdult: Bool

    public enum CodingKeys: String, CodingKey {
        case id, name, description, category, isGeneralSpoiler, isAdult
    }

    public init(id: Int, name: String, description: String? = nil, category: String? = nil, isGeneralSpoiler: Bool = false, isAdult: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.isGeneralSpoiler = isGeneralSpoiler
        self.isAdult = isAdult
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.isGeneralSpoiler = try container.decodeIfPresent(Bool.self, forKey: .isGeneralSpoiler) ?? false
        self.isAdult = try container.decodeIfPresent(Bool.self, forKey: .isAdult) ?? false
    }
}
