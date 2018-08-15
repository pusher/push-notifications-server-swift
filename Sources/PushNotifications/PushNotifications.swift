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

/**
PushNotifications struct implements publish method
that is used to publish push notifications to specified interests.

- Precondition: `instanceId` should not be an empty string.
- Precondition: `secretKey` should not be an empty string.
*/
public struct PushNotifications {
    /// Pusher Beams Instance Id
    private let instanceId: String
    /// Pusher Beams Secret Key
    private let secretKey: String

    /**
     Creates a new `PushNotifications` instance.

     - Parameter instanceId: Pusher Beams Instance Id.
     - Parameter secretKey: Pusher Beams Secret Key.
    */
    public init(instanceId: String, secretKey: String) {
        self.instanceId = instanceId
        self.secretKey = secretKey
    }

    /**
    Publish the given `publishRequest` to the specified interests.

    - Parameter interests: Array of strings that contains interests.
    - Parameter publishRequest: Dictionary containing the body of the push notification publish request.
    - Parameter completion: The block to execute when the `publish` operation is complete.

    - Throws: An error of type `PushNotificationsError`.

    - returns: Publish Id.

    Example usage:
 
    ````
    // Pusher Beams Instance Id.
    let instanceId = "c7c52433-8c65-43e6-9ef2-922d9ed9e196"
    // Pusher Beams Secret Key.
    let secretKey = "39817C9BCBF7F053CB151343D54EE75"

    // PushNotifications instance.
    let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

    // Interests array.
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

    // Call the publish method.
    try? pushNotifications.publish(interests, publishRequest) { publishId in 
        print(publishId)
    }
    ````
    */
    public func publish(_ interests: [String], _ publishRequest: [String: Any], completion: @escaping (_ publishId: String) -> Void) throws {

        if instanceId.isEmpty {
            throw PushNotificationsError.instanceIdCannotBeAnEmptyString
        }

        if secretKey.isEmpty {
            throw PushNotificationsError.secretKeyCannotBeAnEmptyString
        }

        if interests.isEmpty {
            throw PushNotificationsError.interestsArrayCannotBeEmpty
        }

        if interests.count > 100 {
            throw PushNotificationsError.interestsArrayContainsTooManyInterests(maxInterests: 100)
        }

        if !(interests.filter { $0.count > 164 }).isEmpty {
            throw PushNotificationsError.interestsArrayContainsAnInvalidInterest(maxCharacters: 164)
        }

        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)

        let urlString = "https://\(instanceId).pushnotifications.pusher.com/publish_api/v1/instances/\(instanceId)/publishes"
        guard let url = URL(string: urlString) else { return }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")

        var mutablePublishRequest = publishRequest
        mutablePublishRequest["interests"] = interests

        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: mutablePublishRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard
                let data = data,
                let httpURLResponse = response as? HTTPURLResponse
                else {
                    return // Improve
            }

            let statusCode = httpURLResponse.statusCode
            guard statusCode >= 200 && statusCode < 300, error == nil else {
                return // Improve
            }

            if let publishResponse = try? JSONDecoder().decode(PublishResponse.self, from: data) {
                completion(publishResponse.id)
            }
        }

        dataTask.resume()
    }
}

private struct PublishResponse: Decodable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "publishId"
    }
}
