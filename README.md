# AniList Swift SDK

A powerful, robust, and strongly-typed Swift client for interacting with the [AniList GraphQL API](https://anilist.co/graphiql). 

This SDK was built using Protocol-Oriented Swift and fully leverages `Codable`, modern `async/await` Swift Concurrency, and modular generic networking.

## Features
- **Strictly Typed GraphQL Models**: Full Swift equivalents for heavily used models like `Media`, `User`, `Character`, `Staff`, `Studio`, `Activity`, and `MediaList`.
- **Automatic OAuth2 Management**: Transparently attach your auth tokens via the `tokenProvider` closure.
- **Robust Error Handling**: Specific errors parsed for Rate Limits (HTTP 429), Network failures, and specific GraphQL constraint violations.
- **Protocol-Oriented Query Execution**: A generic `execute<T: GraphQLRequest>(...)` pipeline ensures that responses are correctly mapped from API right to domain-level Swift structs.
- **Mutation Support**: First-class support for POST mutations like saving and updating list entries.
- **Linted & Tested**: Maintained with strict `.swiftlint.yml` library rules, 100% compliant code, and thorough `XCTest` coverage using a thread-safe `MockURLProtocol`.

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/AtiinLabs/anilist-sdk.git", from: "1.0.0")
]
```

The hosted DocC site and the `swift-docc-plugin` dependency were removed so apps that use the SDK don't resolve a documentation-only package. Whether to restore them is decided after Ito's AniList migration; see the note in `Package.swift`.

## Quick Start

### Basic Client Setup

To fetch public data, you can initialize the client without authentication:

```swift
import anilist

let client = AniListClient()

Task {
    do {
        // Build the query
        let query = AniListQueries.MediaQuery(id: 15125)
        
        // Execute
        let response = try await client.execute(query)
        
        if let media = response.media {
            print("Title: \(media.title?.romaji ?? "Unknown")")
            print("Status: \(media.status?.rawValue ?? "Unknown")")
        }
    } catch {
        print("Failed to fetch media: \(error)")
    }
}
```

### Authenticated Client Setup

To interact with private user lists or execute mutations, supply a `tokenProvider`:

```swift
import anilist

let client = AniListClient {
    // Retrieve your valid token from the Keychain or an OAuth2 manager
    return await KeychainManager.shared.getAccessToken()
}

Task {
    do {
        // Execute a mutation
        let saveEntry = SaveMediaListEntryMutation(mediaId: 15125, status: .current, progress: 5)
        let response = try await client.execute(saveEntry)
        
        print("Updated entry progress to: \(response.saveMediaListEntry.progress ?? 0)")
    } catch {
        print("Failed to save entry: \(error)")
    }
}
```

## Architecture

This SDK leverages a `GraphQLRequest` protocol for unifying queries and mutations:

```swift
public protocol GraphQLRequest {
    associatedtype Response: Decodable
    associatedtype Variables: Encodable
    
    var query: String { get }
    var variables: Variables? { get }
}
```

Each query provides the raw `String` payload alongside its typed variables. The generic `AniListClient` handles encoding the request and decoding the defined `Response`.

## Testing

The SDK test suite uses a thread-safe `MockURLProtocol` (which leverages Swift 6 `nonisolated(unsafe)`) for fast, deterministic unit testing without hitting the network. Ensure you run the suite via:

```bash
swift test
```

## Contributing
We welcome contributions to expand the SDK's coverage of the AniList schema! Please make sure that your contributions:
1. Pass all tests (`swift test`).
2. Adhere to the library's linting rules (`swiftlint`).
3. Add appropriate `try XCTUnwrap` unit tests for any new `Codable` models.

## License
MIT License.
