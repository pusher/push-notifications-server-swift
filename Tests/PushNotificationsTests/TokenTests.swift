@testable import PushNotifications
import XCTest

final class TokenTests: XCTestCase {

    func testItShouldAuthenticateTheUserSuccessfully() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.generateToken(TestObjects.UserIDs.validId) { result in
            self.verifyResultSuccess(result, expectation: exp) { jwt in
                XCTAssertNotNil(jwt)
            }
        }

        wait(for: [exp], timeout: 3)
    }

    func testItShouldFailToGenerateTokenWithEmptyId() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.generateToken(TestObjects.UserIDs.emptyString) { result in
            self.verifyResultFailure(result,
                                     expectation: exp,
                                     expectedError: .userIdCannotBeAnEmptyString)
        }

        wait(for: [exp], timeout: 3)
    }

    func testItShouldFailToGenerateTokenWithIdThatIsTooLong() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.generateToken(TestObjects.UserIDs.tooLong) { result in
            self.verifyResultFailure(result,
                                     expectation: exp,
                                     expectedError: .userIdInvalid(maxCharacters: 164))
        }

        wait(for: [exp], timeout: 3)
    }
}
