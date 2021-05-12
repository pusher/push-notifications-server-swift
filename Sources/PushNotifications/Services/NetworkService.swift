import Foundation

struct NetworkService {

    enum PublishType: String {
        case interests
        case users
    }

    let instanceId: String

    let secretKey: String

    // MARK: - Private properties

    var host: String {
        "\(instanceId).pushnotifications.pusher.com"
    }

    var baseUrlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host

        return components
    }

    // MARK: - Interests

    func publishToInterests(_ interests: [String],
                            publishRequest: [String: Any],
                            completion: @escaping (_ result: Result<String, Error>) -> Void) {
        publish(to: interests,
                type: .interests,
                publishRequest: publishRequest,
                completion: completion)
    }

    // MARK: - Users

    func publishToUsers(_ users: [String],
                        publishRequest: [String: Any],
                        completion: @escaping (_ result: Result<String, Error>) -> Void) {
        publish(to: users,
                type: .users,
                publishRequest: publishRequest,
                completion: completion)
    }

    func deleteUser(_ userId: String,
                    completion: @escaping (_ result: Result<Void, Error>) -> Void) {

        do {
            let url = try endpointUrl(path: "/customer_api/v1/instances/\(instanceId)/users/\(userId)")

            let request = urlRequest(for: url,
                                     httpMethod: "DELETE")

            networkRequest(request: request) { result in
                switch result {
                case .success:
                    completion(.success(()))

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Private methods

    private func endpointUrl(path: String) throws -> URL {
        var components = baseUrlComponents
        components.path = path

        guard let url = components.url else {
            let errorMessage = """
            [PushNotifications] - Error while constructing the URL.\nCheck that the URL string is not \
            an empty string or string contains illegal characters.
            """
            throw PushNotificationsError.error(errorMessage)
        }

        return url
    }

    private func publish(to objects: [String],
                         type: PublishType,
                         publishRequest: [String: Any],
                         completion: @escaping (_ result: Result<String, Error>) -> Void) {

        var mutablePublishRequest = publishRequest
        mutablePublishRequest[type.rawValue] = objects

        do {
            let httpBody = try JSONSerialization.data(withJSONObject: mutablePublishRequest)

            var endpointPath = "/publish_api/v1/instances/\(instanceId)/publishes"
            if case .users = type {
                endpointPath += "/users"
            }
            let url = try endpointUrl(path: endpointPath)

            let request = urlRequest(for: url,
                                     httpMethod: "POST",
                                     body: httpBody)

            networkRequest(request: request) { result in
                switch result {
                case .success(let deviceData):
                    do {
                        let publishResponse = try JSONDecoder().decode(PublishResponse.self, from: deviceData)
                        completion(.success(publishResponse.id))
                    } catch {
                        completion(.failure(error))
                    }

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    private func networkRequest(request: URLRequest,
                                completion: @escaping (_ result: Result<Data, Error>) -> Void) {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)

        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                let errorMessage = "[PushNotifications] - Publish request failed. `data` is nil."
                return completion(.failure(PushNotificationsError.error(errorMessage)))
            }
            guard let httpURLResponse = response as? HTTPURLResponse else {
                let errorMessage = "[PushNotifications] - Publish request failed. `httpURLResponse` is nil."
                return completion(.failure(PushNotificationsError.error(errorMessage)))
            }

            let statusCode = httpURLResponse.statusCode
            guard statusCode >= 200 && statusCode < 300, error == nil else {
                let errorMessage = "[PushNotifications] - Request failed. HTTP status code: \(statusCode)"
                return completion(.failure(PushNotificationsError.error(errorMessage)))
            }

            completion(.success(data))
        }

        dataTask.resume()
    }

    private func urlRequest(for url: URL,
                            httpMethod: String,
                            body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")
        request.setValue("push-notifications-server-swift \(SDKVersion.current)",
                         forHTTPHeaderField: "X-Pusher-Library")
        request.httpMethod = httpMethod
        request.httpBody = body

        return request
    }
}
