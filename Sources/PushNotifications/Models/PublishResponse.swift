import Foundation

struct PublishResponse: Decodable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "publishId"
    }
}
