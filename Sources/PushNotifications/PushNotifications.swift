import Foundation

enum PushNotificationsError: Error {
    case instanceIdCannotBeAnEmptyString
    case secretKeyCannotBeAnEmptyString
    case interestsArrayCannotBeEmpty
    case interestsArrayContainsTooManyInterests(maxInterests: UInt)
    case interestsArrayContainsAnInvalidInterest(maxCharacters: UInt)
    case somethingWentWrong // Rename
}

struct PushNotifications {
    let instanceId: String
    let secretKey: String

    func publish(_ interests: [String], _ publishRequest: [String: Any], completion: @escaping (_ publishId: String) -> Void) throws {

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
