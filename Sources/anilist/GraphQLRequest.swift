import Foundation

/// A protocol representing a single GraphQL request (query or mutation).
public protocol GraphQLRequest: Sendable {
    /// The expected decodable response type.
    associatedtype Response: Decodable & Sendable
    
    /// The type of the variables. Use `String` or a custom struct.
    associatedtype Variables: Encodable & Sendable
    
    /// The raw GraphQL query string.
    var query: String { get }
    
    /// The variables for the query.
    var variables: Variables? { get }
}

/// A default extension to provide nil variables for requests that don't need them.
public extension GraphQLRequest {
    /// Default variables are nil.
    var variables: String? { nil }
}
