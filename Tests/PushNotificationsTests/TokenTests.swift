@testable import PushNotifications
import XCTest

final class TokenTests: XCTestCase {

    func testItShouldAuthenticateTheUserSuccessfully() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let exp = expectation(description: "It should successfully authenticate the user.")

        pushNotifications.generateToken("aaa") { result in
            switch result {
            case .success(let jwtToken):
                // 'jwtToken' is a Dictionary<String, String>
                // Example: ["token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhYWEiLCJleHAiOjE"]
                XCTAssertNotNil(jwtToken)
                exp.fulfill()

            case .failure:
                XCTFail("Result should not contain an error.")
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testItShouldFailToGenerateTokenWithEmptyId() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let exp = expectation(description: "It should return an error.")

        pushNotifications.generateToken("") { result in
            switch result {
            case .success:
                XCTFail("Result should not contain a value.")

            case .failure(let error):
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testItShouldFailToGenerateTokenWithIdThatIsTooLong() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let exp = expectation(description: "It should return an error.")

        pushNotifications.generateToken("""
        askdsakdjlksajkldjkajdksjkdjkjkjdkajksjkljkajkdsjkajkdjkoiwqjijiofiowenfioneiveniow\
        nvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinv\
        ioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinvioenioniwenvioiwnivei\
        niowenviwniwvnienoin
        """) { result in
            switch result {
            case .success:
                XCTFail("Result should not contain a value.")

            case .failure(let error):
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 3)
    }
}
