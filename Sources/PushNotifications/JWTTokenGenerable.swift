import Foundation
import SwiftJWT

public struct JWTPayload {
    let sub: String
    let exp: Date
    let iss: String
    let key: String
}

public protocol JWTTokenGenerable {
    func jwtTokenString(payload: JWTPayload, completion: @escaping CompletionHandler<Result<String, Error>>)
}

private struct JWTClaims: Claims {
    let sub: String
    let exp: Date
    let iss: String
}

public extension JWTTokenGenerable {
    func jwtTokenString(payload: JWTPayload, completion: @escaping CompletionHandler<Result<String, Error>>) {
        let key = payload.key.data(using: .utf8)!
        let jwtEncoder = JWTEncoder(jwtSigner: JWTSigner.hs256(key: key))
        do {
            let jwt = JWT(claims: JWTClaims(sub: payload.sub, exp: payload.exp, iss: payload.iss))
            let jwtTokenString = try jwtEncoder.encodeToString(jwt)
            completion(.value(jwtTokenString))
        } catch {
            completion(.error(error))
        }
    }
}
