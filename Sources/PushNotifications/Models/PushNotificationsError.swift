import Foundation

/// Error thrown by PushNotifications.
public enum PushNotificationsError: LocalizedError {

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

    /// An internal error occured.
    ///
    /// Some internal operation of the library has thrown an error. The reason for the failure
    /// can be inspected via the `localizedDescription` property of the `error` parameter.
    case internalError(_ error: Error)

    /// The `secretKey` cannot be an empty String.
    case secretKeyCannotBeAnEmptyString

    /// The `users` array cannot be empty.
    case usersArrayCannotBeEmpty

    /// The `users` array cannot contain any empty Strings.
    case usersArrayCannotContainEmptyString

    /// The `users` array contains at least one or more invalid users.
    /// - maxCharacters: The maximum number of characters allowed.
    case usersArrayContainsAnInvalidUser(maxCharacters: UInt)

    /// The `users` array exceeded the number of maximum interests allowed.
    /// - maxUsers: The maximum number of interests allowed.
    case usersArrayContainsTooManyUsers(maxUsers: UInt)

    /// The `userId` cannot be an empty String.
    case userIdCannotBeAnEmptyString

    /// The `userId` is invalid (i.e. it is too many characters).
    /// - maxCharacters: The maximum number of characters allowed.
    case userIdInvalid(maxCharacters: UInt)

    public var errorDescription: String? {
        switch self {
        case .instanceIdCannotBeAnEmptyString:
            return NSLocalizedString("The network response does not contain any data.",
                                     comment: "'.instanceIdCannotBeAnEmptyString' error text")

        case .interestsArrayCannotBeEmpty:
            return NSLocalizedString("The 'interests' array cannot be empty.",
                                     comment: "'.interestsArrayCannotBeEmpty' error text")

        case .interestsArrayContainsAnInvalidInterest(maxCharacters: let maxCharacters):
            return NSLocalizedString("""
            The 'interests' array contains at least one interest longer than \(maxCharacters) characters.
            """,
                                     comment: "'.interestsArrayContainsAnInvalidInterest' error text")

        case .interestsArrayContainsTooManyInterests(maxInterests: let maxInterests):
            return NSLocalizedString("The 'interests' array cannot contain more than \(maxInterests) interests.",
                                     comment: "'.interestsArrayContainsTooManyInterests' error text")

        case .internalError(let error):
            return NSLocalizedString("The request failed with error: \(error)",
                                     comment: "'.internalError' error text")

        case .secretKeyCannotBeAnEmptyString:
            return NSLocalizedString("The 'secretKey' cannot be an empty string.",
                                     comment: "'.secretKeyCannotBeAnEmptyString' error text")

        case .usersArrayCannotBeEmpty:
            return NSLocalizedString("The 'users' array cannot be empty.",
                                     comment: "'.usersArrayCannotBeEmpty' error text")

        case .usersArrayCannotContainEmptyString:
            return NSLocalizedString("The 'users' array cannot contain any user IDs that are empty strings.",
                                     comment: "'.usersArrayCannotContainEmptyString' error text")

        case .usersArrayContainsAnInvalidUser(maxCharacters: let maxCharacters):
            return NSLocalizedString("""
            The 'users' array contains at least one user ID longer than \(maxCharacters) characters.
            """,
                                     comment: "'.usersArrayContainsAnInvalidUser' error text")

        case .usersArrayContainsTooManyUsers(maxUsers: let maxUsers):
            return NSLocalizedString("The 'users' array cannot contain more than \(maxUsers) user IDs.",
                                     comment: "'.usersArrayContainsTooManyUsers' error text")

        case .userIdCannotBeAnEmptyString:
            return NSLocalizedString("The 'userId' cannot be an empty string.",
                                     comment: "'.userIdCannotBeAnEmptyString' error text")

        case .userIdInvalid(maxCharacters: let maxCharacters):
            return NSLocalizedString("The 'userId' is longer than \(maxCharacters) characters.",
                                     comment: "'.userIdInvalid' error text")
        }
    }
}

extension PushNotificationsError {

    /// Creates a `PushNotificationsError` which wraps another `Error`,
    /// offering additional context if it can be determined.
    /// - Parameter error: The `Error` to wrap inside the resulting `PushNotificationsError`.
    init(from error: Error) {

        // Handle the case where `error` is already a `PushNotificationsError`
        if error is PushNotificationsError {
            // swiftlint:disable:next force_cast
            self = error as! PushNotificationsError
            return
        } else {
            self = .internalError(error)
        }
    }
}

extension PushNotificationsError: Equatable {

    public static func == (lhs: PushNotificationsError, rhs: PushNotificationsError) -> Bool {
        switch (lhs, rhs) {
        case (.instanceIdCannotBeAnEmptyString, .instanceIdCannotBeAnEmptyString):
            return true

        case (.interestsArrayCannotBeEmpty, .interestsArrayCannotBeEmpty):
            return true

        case (.interestsArrayContainsAnInvalidInterest(let maxOne), .interestsArrayContainsAnInvalidInterest(let maxTwo)):
            return maxOne == maxTwo

        case (.interestsArrayContainsTooManyInterests(let maxOne), .interestsArrayContainsTooManyInterests(let maxTwo)):
            return maxOne == maxTwo

        case (.internalError(let errorOne), .internalError(let errorTwo)):
            return errorOne.localizedDescription == errorTwo.localizedDescription

        case (.secretKeyCannotBeAnEmptyString, .secretKeyCannotBeAnEmptyString):
            return true

        case (.usersArrayCannotBeEmpty, .usersArrayCannotBeEmpty):
            return true

        case (.usersArrayCannotContainEmptyString, .usersArrayCannotContainEmptyString):
            return true

        case (.usersArrayContainsAnInvalidUser(let maxOne), .usersArrayContainsAnInvalidUser(let maxTwo)):
            return maxOne == maxTwo

        case (.usersArrayContainsTooManyUsers(let maxOne), .usersArrayContainsTooManyUsers(let maxTwo)):
            return maxOne == maxTwo

        case (.userIdCannotBeAnEmptyString, .userIdCannotBeAnEmptyString):
            return true

        case (.userIdInvalid(let maxOne), .userIdInvalid(let maxTwo)):
            return maxOne == maxTwo

        default:
            return false
        }
    }
}
