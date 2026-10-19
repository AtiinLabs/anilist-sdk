# AniList SDK API Reference

This document serves as the technical reference for the public interfaces exposed by the AniList SDK.

## Core Components

### `AniListClient`
The primary interface for executing API requests.

**Initialization:**
```swift
public init(session: URLSession = .shared, tokenProvider: (@Sendable () async throws -> String?)? = nil)
```
- `session`: Custom `URLSession` for network requests.
- `tokenProvider`: A closure returning a Bearer token string (or nil) for authenticated requests.

**Methods:**
```swift
public func execute<R: GraphQLRequest>(_ request: R) async throws -> R.Response
```
Executes a generic request conforming to `GraphQLRequest` and decodes the typed `Response`.

### `GraphQLRequest` (Protocol)
The foundational protocol for all queries and mutations.

```swift
public protocol GraphQLRequest: Sendable {
    associatedtype Response: Decodable & Sendable
    associatedtype Variables: Encodable & Sendable
    
    var query: String { get }
    var variables: Variables? { get }
}
```

### `AniListError` (Enum)
Error types thrown by the `AniListClient`.
- `.networkError(URLError)`: Underlying network transport failures.
- `.httpError(statusCode: Int)`: Non-2xx responses without a GraphQL error body.
- `.rateLimitExceeded(retryAfter: Int?)`: Hit rate limit (HTTP 429).
- `.graphqlErrors([GraphQLError])`: Errors returned by AniList, including the non-2xx not found (404), unauthorized (401) and validation (400) responses.
- `.decodingError(String)`: Swift parsing / Codable failures.

`isNotFound` is true for AniList 404s: a missing media, list entry or user, or a private user's lists. `localizedDescription` uses AniList's error messages.

---

## Supported Queries

All queries are located in `Sources/anilist/Queries/`. You initialize the query with its required/optional variables and pass it to `client.execute()`.

### `ViewerQuery`
Fetches the currently authenticated user's profile information.
**Response Data:** `User`

### `MediaQuery`
Fetches a specific Anime or Manga by its properties (like ID or search term).
**Variables:** `id`, `search`, `type`, etc.
**Response Data:** `Media`

### `MediaListCollectionQuery`
Fetches a user's lists (e.g., all Anime they have watched or are currently watching).
**Variables:** `userId`, `userName`, `type`, `statusIn`, `forceSingleCompletedList`, `chunk`, `perChunk`
**Response Data:** `MediaListCollection` (containing arrays of `MediaListGroup` and `MediaList`). Large lists are split into chunks; request the next `chunk` while `hasNextChunk` is true.

### `MediaListEntryQuery`
Fetches one list entry by entry `id`, or by `userId`/`userName` and `mediaId`. A user without an entry for the media answers 404, so catch `AniListError` and check `isNotFound`.
**Response Data:** `MediaList`

### `ActivityQuery`
Fetches global or user-specific social feeds.
**Variables:** `userId`, `mediaId`, `type`, etc.
**Response Data:** `Activity` (An enum handling `TextActivity`, `ListActivity`, and `MessageActivity`).

### Entity Queries
- **`CharacterQuery`**: Fetches details on an anime/manga character.
- **`StaffQuery`**: Fetches details on voice actors, directors, animators, etc.
- **`StudioQuery`**: Fetches details on animation studios.

---

## Supported Mutations

All mutations are located in `Sources/anilist/Mutations/`.

### `SaveMediaListEntryMutation`
Creates or updates a list entry. Fields left `nil` are not sent and keep their current values.
**Variables:** `id` (list entry ID), `mediaId`, `status`, `score`, `scoreRaw`, `progress`, `progressVolumes`, `repeat`, `priority`, `private`, `notes`, `hiddenFromStatusLists`, `customLists`, `startedAt`, `completedAt`
**Response Data:** `MediaList`

### `DeleteMediaListEntryMutation`
Deletes a list entry by its entry `id` (`MediaList.id`, not the media id).
**Response Data:** `Deleted`

*(Note: Mutations require the client to be initialized with a valid `tokenProvider`)*

---

## Core Models

All models conform to `Decodable`, `Equatable`, and `Sendable`. For models wrapping union types (e.g., `Activity`), an enum with associated values is used. 

*See `Sources/anilist/Models/` for exact field definitions mapping to the [AniList GraphQL Schema](https://anilist.co/graphiql).*
