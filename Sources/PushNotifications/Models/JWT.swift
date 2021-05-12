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

    init(sub: String,
         exp: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
         iss: String,
         key: String) {
        self.sub = sub
        self.exp = Int(exp.timeIntervalSince1970)
        self.iss = iss
        self.key = key
    }
}
