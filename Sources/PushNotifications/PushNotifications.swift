import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias CompletionHandler<T> = (_ result: T) -> Void

public enum Result<Value, Error> {
    case value(Value)
    case error(Error)
}

/**
PushNotifications struct implements publish method
that is used to publish push notifications to specified interests.

- Precondition: `instanceId` should not be an empty string.
- Precondition: `secretKey` should not be an empty string.
*/
public struct PushNotifications: JWTTokenGenerable {

    /// Pusher Beams Instance Id
    private let instanceId: String

    /// Pusher Beams Secret Key
    private let secretKey: String

    /// Network service
    private let networkService: NetworkService

    private let maxUserIdLength = 164
    private let maxNumUserIdsWhenPublishing = 1000
    private let tokenTTL = Int(Date().timeIntervalSince1970 + 24 * 60 * 60)

    /**
     Creates a new `PushNotifications` instance.

     - Parameter instanceId: Pusher Beams Instance Id.
     - Parameter secretKey: Pusher Beams Secret Key.
    */
    public init(instanceId: String, secretKey: String) {
        self.instanceId = instanceId
        self.secretKey = secretKey
        self.networkService = NetworkService(instanceId: instanceId, secretKey: secretKey)
    }

   /**
    Publish the given `publishRequest` to the specified interests.
    - Parameter interests: Array of strings that contains interests.
    - Parameter publishRequest: Dictionary containing the body of the push notification publish request.
    - Parameter completion: The block to execute when the `publish` operation is complete.
    - Throws: An error of type `PushNotificationsError`.
    - returns: Publish id.
    Example usage:

    ````
    // Pusher Beams Instance Id.
    let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
    // Pusher Beams Secret Key.
    let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"
    // PushNotifications instance.
    let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

    let interests = ["pizza", "donuts"]
    // Publish request: APNs, FCM.
    let publishRequest = [
        "apns": [
            "aps": [
                "alert": "Hello"
            ]
        ],
        "fcm": [
            "notification": [
                "title": "Hello",
				"body":  "Hello, world",
            ]
        ]
    ]

    try? pushNotifications.publish(interests, publishRequest) { publishId in
        print(publishId)
    }
    ````
    */
    @available(*,
    deprecated,
    renamed: "publishToInterests(_:_:completion:)",
    message: "Use 'publishToInterests(_:_:completion:)' method.")
    public func publish(_ interests: [String],
                        _ publishRequest: [String: Any],
                        completion: @escaping (_ publishId: String) -> Void) throws {
        publishToInterests(interests, publishRequest) { result in
            switch result {
            case .value(let deviceId):
                completion(deviceId)

            case .error(let error):
                /**
                 Communicationg errors by returning an empty string is not ideal.
                 Better option would be to set the `publishId` as an optional
                 or to return the proper error which is implemented in `publishToInterests` method.

                 This is a workaround so we don't break the API.
                 **/
                print("[PushNotifications] - Publish request failed: \(error)")
                completion("")
            }
        }
    }

    /**
    Publish the given `publishRequest` to the specified interests.
    - Parameter interests: Array of strings that contains interests.
    - Parameter publishRequest: Dictionary containing the body of the push notification publish request.
    - Parameter completion: The block to execute when the `publishToInterests` operation is complete.
    - returns: A non-empty device id string if successful; or a non-nil `PushNotificationsError` error otherwise.
    Example usage:

    ````
    // Pusher Beams Instance Id.
    let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
    // Pusher Beams Secret Key.
    let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"
    // PushNotifications instance.
    let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

    let interests = ["pizza", "donuts"]
    // Publish request: APNs, FCM.
    let publishRequest = [
        "apns": [
            "aps": [
                "alert": "Hello"
            ]
        ],
        "fcm": [
            "notification": [
                "title": "Hello",
				"body":  "Hello, world",
            ]
        ]
    ]

    pushNotifications.publishToInterests(interests, publishRequest) { result in
        switch result {
        case .value(let publishId):
            print("Publish id: \(publishId)")
        case .error(let error):
            print("Error: \(error)")
        }
    }
    ````
    */
    public func publishToInterests(_ interests: [String],
                                   _ publishRequest: [String: Any],
                                   completion: @escaping CompletionHandler<Result<String, Error>>) {
        if instanceId.isEmpty {
            return completion(.error(PushNotificationsError.instanceIdCannotBeAnEmptyString))
        }

        if secretKey.isEmpty {
            return completion(.error(PushNotificationsError.secretKeyCannotBeAnEmptyString))
        }

        if interests.isEmpty {
            return completion(.error(PushNotificationsError.interestsArrayCannotBeEmpty))
        }

        if interests.count > 100 {
            return completion(.error(PushNotificationsError.interestsArrayContainsTooManyInterests(maxInterests: 100)))
        }

        if !(interests.filter { $0.count > 164 }).isEmpty {
            // swiftlint:disable:next line_length
            return completion(.error(PushNotificationsError.interestsArrayContainsAnInvalidInterest(maxCharacters: 164)))
        }

        networkService.publishToInterests(interests,
                                          publishRequest: publishRequest,
                                          completion: completion)
    }

    /**
    Publish the given `publishRequest` to the specified users.
    - Parameter users: Array of strings that contains user ids.
    - Parameter publishRequest: Dictionary containing the body of the push notification publish request.
    - Parameter completion: The block to execute when the `publishToUsers` operation is complete.
    - returns: A non-empty publish id string if successful; or a non-nil `PushNotificationsError` error otherwise.
    Example usage:

    ````
    // Pusher Beams Instance Id.
    let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
    // Pusher Beams Secret Key.
    let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"
    // PushNotifications instance.
    let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

    let users = ["user1", "user2", "user3"]
    // Publish request: APNs, FCM.
    let publishRequest = [
        "apns": [
            "aps": [
                "alert": "Hello"
            ]
        ],
        "fcm": [
            "notification": [
                "title": "Hello",
                "body":  "Hello, world",
            ]
        ]
    ]

    pushNotifications.publishToUsers(users, publishRequest) { result in
        switch result {
        case .value(let publishId):
            print("Publish id: \(publishId)")
        case .error(let error):
            print("Error: \(error)")
        }
    }
    ````
    */
    public func publishToUsers(_ users: [String],
                               _ publishRequest: [String: Any],
                               completion: @escaping CompletionHandler<Result<String, Error>>) {
        if users.count < 1 {
            let errorMessage = "[PushNotifications] - Must supply at least one user id."
            return completion(.error(PushNotificationsError.error(errorMessage)))
        }

        if users.count > maxNumUserIdsWhenPublishing {
            let errorMessage = """
            [PushNotifications] - Too many user ids supplied. \
            API supports up to \(maxNumUserIdsWhenPublishing), got \(users.count)
            """
            return completion(.error(PushNotificationsError.error(errorMessage)))
        }

        let usersContainsAnEmptyString = users.contains("")
        if usersContainsAnEmptyString {
            let errorMessage = "[PushNotifications] - Empty user ids are not valid."
            return completion(.error(PushNotificationsError.error(errorMessage)))
        }

        let usersContainsUserIdWithInvalidLength = users.map { $0.count > maxUserIdLength }.contains(true)
        if usersContainsUserIdWithInvalidLength {
            let errorMessage = """
            [PushNotifications] - User Id length too long (expected fewer than \(maxUserIdLength+1) characters)
            """
            return completion(.error(PushNotificationsError.error(errorMessage)))
        }

        networkService.publishToUsers(users,
                                      publishRequest: publishRequest,
                                      completion: completion)
    }

    /**
    Creates a signed JWT for a user id.
    - Parameter userId: Id of a user for which we want to generate the JWT token.
    - Parameter completion: The block to execute when the `generateToken` operation is complete.
    - returns: A signed JWT if successful, or a non-nil `PushNotificationsError` error otherwise.
    Example usage:

    ````
    // Pusher Beams Instance Id.
    let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
    // Pusher Beams Secret Key.
    let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"
    // PushNotifications instance.
    let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

    pushNotifications.generateToken("Al Pacino", completion: { result in
        switch result {
        case .value(let jwtToken):
            print("\(jwtToken)")
        case .error(let error):
            print("\(error)")
        }
    })
    ````
    */
    public func generateToken(_ userId: String,
                              completion: @escaping CompletionHandler<Result<[String: String], Error>>) {
        if userId.count < 1 {
            return completion(.error(PushNotificationsError.error("User Id cannot be empty")))
        }

        if userId.count > maxUserIdLength {
            let errorMessage = """
            [PushNotifications] - User Id \(userId) length too long \
            (expected fewer than \(maxUserIdLength+1) characters, got \(userId.count)
            """
            return completion(.error(PushNotificationsError.error(errorMessage)))
        }

        let jwtPayload = JWTPayload(sub: userId,
                                    exp: tokenTTL,
                                    iss: networkService.host,
                                    key: secretKey)
        jwtTokenString(payload: jwtPayload) { result in
            switch result {
            case .value(let jwtTokenString):
                completion(.value(["token": jwtTokenString]))

            case .error(let error):
                completion(.error(error))
            }
        }
    }

    /**
    Contacts the Beams service to remove all the devices of the given user.
    - Parameter userId: Id of a user for which we want to remove all the devices.
    - Parameter completion: The block to execute when the `deleteUser` operation is complete.
    - returns: Void if successful, or a non-nil `PushNotificationsError` error otherwise.
    Example usage:

    ````
    // Pusher Beams Instance Id.
    let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
    // Pusher Beams Secret Key.
    let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"
    // PushNotifications instance.
    let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

    pushNotifications.deleteUser("Al Pacino", completion: { result in
        switch result {
        case .value:
            print("User deleted 👌")
        case .error(let error):
            print("\(error)")
        }
    })
    ````
    */
    public func deleteUser(_ userId: String,
                           completion: @escaping CompletionHandler<Result<Void, Error>>) {
        if userId.count < 1 {
            return completion(.error(PushNotificationsError.error("[PushNotifications] - User Id cannot be empty.")))
        }

        if userId.count > maxUserIdLength {
            let errorMessage = """
            [PushNotifications] - User Id \(userId) length too long \
            (expected fewer than \(maxUserIdLength+1) characters, got \(userId.count)
            """
            return completion(.error(PushNotificationsError.error(errorMessage)))
        }

        networkService.deleteUser(userId, completion: completion)
    }
}
