@testable import PushNotifications
import XCTest

final class TokenTests: XCTestCase {

    func testItShouldAuthenticateTheUserSuccessfully() {
        let exp = expectation(description: "It should successfully authenticate the user.")

        TestObjects.Client.shared.generateToken(TestObjects.UserIDs.validId) { result in
            self.verifyAPIResultSuccess(result, expectation: exp) { jwt in
                XCTAssertNotNil(jwt)
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testItShouldFailToGenerateTokenWithEmptyId() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.generateToken(TestObjects.UserIDs.emptyString) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .userIdCannotBeAnEmptyString)
        }

        waitForExpectations(timeout: 3)
    }

    func testItShouldFailToGenerateTokenWithIdThatIsTooLong() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.generateToken(TestObjects.UserIDs.tooLong) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .userIdInvalid(maxCharacters: 164))
        }

        waitForExpectations(timeout: 3)
    }
}
