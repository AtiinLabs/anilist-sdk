import Foundation

internal extension KeyedDecodingContainer {
    /// Decodes a string-backed enum, mapping values this SDK does not know to `nil`
    /// so a new AniList enum value does not fail the whole response.
    func decodeLossyIfPresent<T: RawRepresentable>(_ type: T.Type, forKey key: Key) throws -> T? where T.RawValue == String {
        guard let rawValue = try decodeIfPresent(String.self, forKey: key) else {
            return nil
        }
        return T(rawValue: rawValue)
    }
}
