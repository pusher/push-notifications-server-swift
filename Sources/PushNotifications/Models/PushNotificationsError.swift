import Foundation

/// Error thrown by PushNotifications.
public enum PushNotificationsError: Error {

    /// A non-specific error.
    /// - Parameter: The error message.
    case error(String)

    /// The `instanceId` cannot be an empty String.
    case instanceIdCannotBeAnEmptyString

    /// The `interests` array cannot be empty.
    case interestsArrayCannotBeEmpty

    /// The `interests` array contains at least one or more invalid interests.
    /// - maxCharacters: The maximum number of characters allowed.
    case interestsArrayContainsAnInvalidInterest(maxCharacters: UInt)

    /// The `interests` array exceeded the number of maximum interests allowed.
    /// - maxInterests: The maximum number of interests allowed.
    case interestsArrayContainsTooManyInterests(maxInterests: UInt)

    case internalError(_ error: Error)

    /// The `secretKey` cannot be an empty String.
    case secretKeyCannotBeAnEmptyString

    /// The `userId` cannot be an empty String.
    case userIdCannotBeAnEmptyString
}
