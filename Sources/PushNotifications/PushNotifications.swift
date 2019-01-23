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
public struct PushNotifications {
    /// Pusher Beams Instance Id
    private let instanceId: String
    /// Pusher Beams Secret Key
    private let secretKey: String
    
    private let maxUserIdLength = 164
    private let maxNumUserIdsWhenPublishing = 1000

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
    @available(*, deprecated, renamed: "publishToInterests(_:_:completion:)", message: "Use 'publishToInterests(_:_:completion:)' method.")
    public func publish(_ interests: [String], _ publishRequest: [String: Any], completion: @escaping (_ publishId: String) -> Void) throws {
        do {
            try publishToInterests(interests, publishRequest) { result in
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
        catch {
            throw PushNotificationsError.error("[PushNotifications] - Publish request failed: \(error)")
        }
    }

    /**
    Publish the given `publishRequest` to the specified interests.
    - Parameter interests: Array of strings that contains interests.
    - Parameter publishRequest: Dictionary containing the body of the push notification publish request.
    - Parameter completion: The block to execute when the `publish` operation is complete.
    - Throws: An error of type `PushNotificationsError`.
    - returns: A non-empty device Id string if successful; or a non-nil error otherwise.
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
    try? pushNotifications.publishToInterests(interests, publishRequest) { result in
        switch result {
        case .value(let deviceId):
            print("Device id: \(deviceId)")
        case .error(let error):
            print("Error: \(error)")
        }
    }
    ````
    */
    public func publishToInterests(_ interests: [String], _ publishRequest: [String: Any], completion: @escaping CompletionHandler<Result<String, Error>>) throws {
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

        let urlString = "https://\(instanceId).pushnotifications.pusher.com/publish_api/v1/instances/\(instanceId)/publishes"
        guard let url = URL(string: urlString) else {
            return completion(.error(PushNotificationsError.error("[PushNotifications] - Error while constructing the URL.\nCheck that the URL string is not an empty string or string contains illegal characters.")))
        }

        var mutablePublishRequest = publishRequest
        mutablePublishRequest["interests"] = interests
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: mutablePublishRequest)
            let request = setRequest(url: url, httpMethod: "POST", body: httpBody)
            
            networkRequest(request: request) { result in
                switch result {
                case .value(let deviceData):
                    do {
                        let publishResponse = try JSONDecoder().decode(PublishResponse.self, from: deviceData)
                        completion(.value(publishResponse.id))
                    }
                    catch {
                        completion(.error(error))
                    }
                case .error(let error):
                    completion(.error(error))
                }
            }
        }
        catch {
            completion(.error(error))
        }
    }
    
    public func publishToUsers(_ users: [String], _ publishRequest: [String: Any], completion: @escaping CompletionHandler<Result<String, Error>>) throws {
        if users.count < 1 {
            throw PushNotificationsError.error("[PushNotifications] - Must supply at least one user id.")
        }
        
        if users.count > maxNumUserIdsWhenPublishing {
            throw PushNotificationsError.error("[PushNotifications] - Too many user ids supplied. API supports up to \(maxNumUserIdsWhenPublishing), got \(users.count)")
        }
        
        let usersArrayContainsAnEmptyString = users.contains("")
        if usersArrayContainsAnEmptyString {
            throw PushNotificationsError.error("[PushNotifications] - Empty user ids are not valid.")
        }
        
        let usersArrayContainsUserIdWithInvalidLength = users.map { $0.count > maxUserIdLength }.contains(true)
        if usersArrayContainsUserIdWithInvalidLength {
            throw PushNotificationsError.error("[PushNotifications] - User Id length too long (expected fewer than \(maxUserIdLength+1) characters)")
        }
        
        let urlString = "https://\(instanceId).pushnotifications.pusher.com/publish_api/v1/instances/\(instanceId)/publishes/users"
        guard let url = URL(string: urlString) else {
            return completion(.error(PushNotificationsError.error("[PushNotifications] - Error while constructing the URL.\nCheck that the URL string is not an empty string or string contains illegal characters.")))
        }
        
        var mutablePublishRequest = publishRequest
        mutablePublishRequest["users"] = users
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: mutablePublishRequest)
            let request = setRequest(url: url, httpMethod: "POST", body: httpBody)
            
            networkRequest(request: request) { result in
                switch result {
                case .value(let publishData):
                    do {
                        let publishResponse = try JSONDecoder().decode(PublishResponse.self, from: publishData)
                        completion(.value(publishResponse.id))
                    }
                    catch {
                        completion(.error(error))
                    }
                case .error(let error):
                    completion(.error(error))
                }
            }
        }
        catch {
            completion(.error(error))
        }
    }
    
    public func deleteUser(_ userId: String, completion: @escaping CompletionHandler<Result<Void, Error>>) throws {
        if userId.count < 1 {
            throw PushNotificationsError.error("[PushNotifications] - User Id cannot be empty.")
        }
        
        if userId.count > maxUserIdLength {
            throw PushNotificationsError.error("[PushNotifications] - User Id \(userId) length too long (expected fewer than \(maxUserIdLength+1) characters, got \(userId.count)")
        }
        
        let urlString = "https://\(instanceId).pushnotifications.pusher.com/user_api/v1/instances/\(instanceId)/users/\(userId)"
        guard let url = URL(string: urlString) else {
            return completion(.error(PushNotificationsError.error("[PushNotifications] - Error while constructing the URL.\nCheck that the URL string is not an empty string or string contains illegal characters.")))
        }
        
        let request = setRequest(url: url, httpMethod: "DELETE")
        
        networkRequest(request: request) { result in
            switch result {
            case .value:
                completion(.value(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    private func networkRequest(request: URLRequest, completion: @escaping (_ result: Result<Data, Error>) -> Void) {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return completion(.error(PushNotificationsError.error("[PushNotifications] - Publish request failed. `data` is nil.")))
            }
            guard let httpURLResponse = response as? HTTPURLResponse else {
                return completion(.error(PushNotificationsError.error("[PushNotifications] - Publish request failed. `httpURLResponse` is nil.")))
            }
            
            let statusCode = httpURLResponse.statusCode
            guard statusCode >= 200 && statusCode < 300, error == nil else {
                return completion(.error(PushNotificationsError.error("[PushNotifications] - Request failed. HTTP status code: \(statusCode)")))
            }
            
            completion(.value(data))
        }
        
        dataTask.resume()
    }
    
    private func setRequest(url: URL, httpMethod: String, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod
        request.httpBody = body
        
        return request
    }
}

private struct PublishResponse: Decodable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "publishId"
    }
}
