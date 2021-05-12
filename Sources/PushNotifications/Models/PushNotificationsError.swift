import Foundation

/// Error thrown by PushNotifications.
public enum PushNotificationsError: Error {
    //// `instanceId` cannot be an empty String.
    case instanceIdCannotBeAnEmptyString
    //// `secretKey` cannot be an empty String.
    case secretKeyCannotBeAnEmptyString
    //// `interests` array cannot be empty.
    case interestsArrayCannotBeEmpty

    /**
     General error.

     - Parameter: error message.
     */
    case error(String)

    /**
    Interests array exceeded the number of maximum interests allowed.

    - Parameter: maximum interests allowed value.
    */
    case interestsArrayContainsTooManyInterests(maxInterests: UInt)
    /**
    Interests array contains at least one or more invalid interests.

    - Parameter: maximum characters allowed value.
    */
    case interestsArrayContainsAnInvalidInterest(maxCharacters: UInt)
}
