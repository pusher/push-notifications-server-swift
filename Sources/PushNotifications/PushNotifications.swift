import Foundation

struct PushNotifications {
    let instanceId: String
    let secretKey: String

    func publish(_ interests: [String], _ publishRequest: [String: Any], completion: @escaping (_ publishId: String?) -> Void) {
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
                completion(nil)
                return
            }

            let statusCode = httpURLResponse.statusCode
            guard statusCode >= 200 && statusCode < 300, error == nil else {
                completion(nil)
                return
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
