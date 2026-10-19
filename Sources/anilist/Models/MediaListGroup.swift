import Foundation

public struct MediaListGroup: Decodable, Equatable, Sendable {
    public let entries: [MediaList]?
    public let name: String?
    public let isCustomList: Bool
    public let isSplitCompletedList: Bool
    public let status: MediaListStatus?
    
    public enum CodingKeys: String, CodingKey {
        case entries, name, isCustomList, isSplitCompletedList, status
    }
    
    public init(
        entries: [MediaList]? = nil,
        name: String? = nil,
        isCustomList: Bool = false,
        isSplitCompletedList: Bool = false,
        status: MediaListStatus? = nil
    ) {
        self.entries = entries
        self.name = name
        self.isCustomList = isCustomList
        self.isSplitCompletedList = isSplitCompletedList
        self.status = status
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.entries = try container.decodeIfPresent([MediaList].self, forKey: .entries)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.isCustomList = try container.decodeIfPresent(Bool.self, forKey: .isCustomList) ?? false
        self.isSplitCompletedList = try container.decodeIfPresent(Bool.self, forKey: .isSplitCompletedList) ?? false
        self.status = try container.decodeLossyIfPresent(MediaListStatus.self, forKey: .status)
    }
}
