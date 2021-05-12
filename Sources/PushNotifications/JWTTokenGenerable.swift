import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import SwiftJWT

protocol JWTTokenGenerable {
    func jwtTokenString(payload: JWTPayload, completion: @escaping CompletionHandler<Result<String, Error>>)
}

extension JWTTokenGenerable {
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
