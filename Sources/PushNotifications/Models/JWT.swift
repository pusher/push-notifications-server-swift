import Foundation
import SwiftJWT

struct JWTClaims: Claims {
    let sub: String
    let exp: Int // not a `Date` because the service currently doesn't support `NumericDate`
    let iss: String
}

struct JWTPayload {
    let sub: String
    let exp: Int
    let iss: String
    let key: String
}
