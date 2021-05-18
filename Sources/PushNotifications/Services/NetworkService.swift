import Foundation

struct NetworkService {

    enum Error: LocalizedError {

        case emptyResponseData

        case failedResponse(statusCode: Int)

        case invalidOrEmptyUrlString

        case invalidPublishRequest

        case unexpectedResponse

        var errorDescription: String? {
            switch self {
            case .emptyResponseData:
                return NSLocalizedString("The network response does not contain any data.",
                                         comment: "'.emptyRepsonseData' error text")

            case .failedResponse(statusCode: let code):
                return NSLocalizedString("The request failed with HTTP status code: \(code)",
                                         comment: "'.failedResponse' error text")

            case .invalidOrEmptyUrlString:
                return NSLocalizedString("The request URL string contains illegal characters or is an empty string.",
                                         comment: "'.invalidOrEmptyUrlString' error text")
            case .invalidPublishRequest:
                return NSLocalizedString("The provided publish request data cannot be represented as JSON.",
                                         comment: "'.invalidPublishRequest' error text")

            case .unexpectedResponse:
                return NSLocalizedString("The response was not of the expected 'HTTPURLResponse' type.",
                                         comment: "'.unexpectedResponse' error text")
            }
        }
    }

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
                            completion: @escaping (_ result: Result<String, Swift.Error>) -> Void) {
        publish(to: interests,
                type: .interests,
                publishRequest: publishRequest,
                completion: completion)
    }

    // MARK: - Users

    func publishToUsers(_ users: [String],
                        publishRequest: [String: Any],
                        completion: @escaping (_ result: Result<String, Swift.Error>) -> Void) {
        publish(to: users,
                type: .users,
                publishRequest: publishRequest,
                completion: completion)
    }

    func deleteUser(_ userId: String,
                    completion: @escaping (_ result: Result<Void, Swift.Error>) -> Void) {

        let urlRequestResult = Result { () -> URLRequest in
            let url = try endpointUrl(path: "/customer_api/v1/instances/\(instanceId)/users/\(userId)")

            return urlRequest(for: url,
                              httpMethod: "DELETE")
        }

        switch urlRequestResult {
        case .success(let request):
            networkRequest(request: request) { responseResult in
                completion(responseResult.flatMap { responseData in
                    Result.success(())
                })
            }

        case .failure(let error):
            completion(.failure(error))
        }
    }

    // MARK: - Private methods

    private func endpointUrl(path: String) throws -> URL {
        var components = baseUrlComponents
        components.path = path

        guard let url = components.url else {
            throw Error.invalidOrEmptyUrlString
        }

        return url
    }

    private func publish(to objects: [String],
                         type: PublishType,
                         publishRequest: [String: Any],
                         completion: @escaping (_ result: Result<String, Swift.Error>) -> Void) {

        var mutablePublishRequest = publishRequest
        mutablePublishRequest[type.rawValue] = objects

        let urlRequestResult = Result { () -> URLRequest in
            guard JSONSerialization.isValidJSONObject(mutablePublishRequest) else {
                throw Error.invalidPublishRequest
            }

            let httpBody = try JSONSerialization.data(withJSONObject: mutablePublishRequest)

            var endpointPath = "/publish_api/v1/instances/\(instanceId)/publishes"
            if case .users = type {
                endpointPath += "/users"
            }
            let url = try endpointUrl(path: endpointPath)

            return urlRequest(for: url,
                              httpMethod: "POST",
                              body: httpBody)
        }

        switch urlRequestResult {
        case .success(let request):
            networkRequest(request: request) { responeResult in
                completion(responeResult.flatMap { responseData in
                    Result {
                        let decodedResponse = try JSONDecoder().decode(PublishResponse.self, from: responseData)
                        return decodedResponse.id
                    }
                })
            }

        case .failure(let error):
            completion(.failure(error))
        }
    }

    private func networkRequest(request: URLRequest,
                                completion: @escaping (_ result: Result<Data, Swift.Error>) -> Void) {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)

        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return completion(.failure(Error.emptyResponseData))
            }
            guard let httpURLResponse = response as? HTTPURLResponse else {
                return completion(.failure(Error.unexpectedResponse))
            }

            let statusCode = httpURLResponse.statusCode
            guard 200...299 ~= statusCode, error == nil else {
                return completion(.failure(Error.failedResponse(statusCode: statusCode)))
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
