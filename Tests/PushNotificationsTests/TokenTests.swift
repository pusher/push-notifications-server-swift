@testable import PushNotifications
import XCTest

final class TokenTests: XCTestCase {

    func testItShouldAuthenticateTheUserSuccessfully() {
        let exp = expectation(description: "It should successfully authenticate the user.")

        TestObjects.Client.shared.generateToken(TestObjects.UserIDs.validId) { result in
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
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.generateToken(TestObjects.UserIDs.emptyString) { result in
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
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.generateToken(TestObjects.UserIDs.tooLong) { result in
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
