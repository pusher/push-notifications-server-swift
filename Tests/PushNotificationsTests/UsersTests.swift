@testable import PushNotifications
import XCTest

final class UsersTests: XCTestCase {

    func testValidPublishToUsers() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.publishToUsers(TestObjects.UserIDs.validArray,
                                                 TestObjects.Publish.publishRequest) { result in
            self.verifyResultSuccess(result, expectation: exp) { publishId in
                XCTAssertNotNil(publishId)
            }
        }

        wait(for: [exp], timeout: 3)
    }

    func testPublishToUsersRequiresAtLeastOneUser() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.publishToUsers(TestObjects.UserIDs.emptyArray,
                                                 TestObjects.Publish.publishRequest) { result in
            self.verifyResultFailure(result,
                                     expectation: exp,
                                     expectedError: .usersArrayCannotBeEmpty)
        }

        wait(for: [exp], timeout: 3)
    }

    func testPublishToUsersUserShouldNotBeAnEmptyString() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.publishToUsers([TestObjects.UserIDs.emptyString],
                                                 TestObjects.Publish.publishRequest) { result in
            self.verifyResultFailure(result,
                                     expectation: exp,
                                     expectedError: .usersArrayCannotContainEmptyString)
        }

        wait(for: [exp], timeout: 3)
    }

    func testPublishToUsersUsernameShouldBeLessThan165Characters() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.publishToUsers([TestObjects.UserIDs.tooLong],
                                                 TestObjects.Publish.publishRequest) { result in
            self.verifyResultFailure(result,
                                     expectation: exp,
                                     expectedError: .usersArrayContainsAnInvalidUser(maxCharacters: 164))
        }

        wait(for: [exp], timeout: 3)
    }

    func testPublishToMoreThan1000UsersShouldFail() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.publishToUsers(TestObjects.UserIDs.tooMany,
                                                 TestObjects.Publish.publishRequest) { result in
            let error = PushNotificationsError.internalError(NetworkService.Error.failedResponse(statusCode: 422))
            self.verifyResultFailure(result,
                                     expectation: exp,
                                     expectedError: error)
        }

        wait(for: [exp], timeout: 3)
    }

    func testItShouldDeleteTheUserSuccessfully() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.deleteUser(TestObjects.UserIDs.validId) { result in
            self.verifyResultSuccess(result, expectation: exp) { voidValue in
                XCTAssertNotNil(voidValue)
            }
        }

        wait(for: [exp], timeout: 3)
    }

    func testItShouldFailToDeleteUserWithEmptyId() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.deleteUser(TestObjects.UserIDs.emptyString) { result in
            self.verifyResultFailure(result,
                                     expectation: exp,
                                     expectedError: .userIdCannotBeAnEmptyString)
        }

        wait(for: [exp], timeout: 3)
    }

    func testItShouldFailToDeleteUserWithIdThatIsTooLong() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.deleteUser(TestObjects.UserIDs.tooLong) { result in
            self.verifyResultFailure(result,
                                     expectation: exp,
                                     expectedError: .userIdInvalid(maxCharacters: 164))
        }

        wait(for: [exp], timeout: 3)
    }
}
