@testable import PushNotifications
import XCTest

final class UsersTests: XCTestCase {

    func testValidPublishToUsers() {
        let exp = expectation(description: "It should successfully publish to users.")

        TestObjects.Client.shared.publishToUsers(TestObjects.UserIDs.validArray,
                                                 TestObjects.Publish.publishRequest) { result in
            self.verifyAPIResultSuccess(result, expectation: exp) { publishId in
                XCTAssertNotNil(publishId)
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testPublishToUsersRequiresAtLeastOneUser() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToUsers(TestObjects.UserIDs.emptyArray,
                                                 TestObjects.Publish.publishRequest) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .usersArrayCannotBeEmpty)
        }

        waitForExpectations(timeout: 3)
    }

    func testPublishToUsersUserShouldNotBeAnEmptyString() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToUsers([TestObjects.UserIDs.emptyString],
                                                 TestObjects.Publish.publishRequest) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .usersArrayCannotContainEmptyString)
        }

        waitForExpectations(timeout: 3)
    }

    func testPublishToUsersUsernameShouldBeLessThan165Characters() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToUsers([TestObjects.UserIDs.tooLong],
                                                 TestObjects.Publish.publishRequest) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .usersArrayContainsAnInvalidUser(maxCharacters: 164))
        }

        waitForExpectations(timeout: 3)
    }

    func testPublishToMoreThan1000UsersShouldFail() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToUsers(TestObjects.UserIDs.tooMany,
                                                 TestObjects.Publish.publishRequest) { result in
            let error = PushNotificationsError.internalError(NetworkService.Error.failedResponse(statusCode: 422))
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: error)
        }

        waitForExpectations(timeout: 3)
    }

    func testItShouldDeleteTheUserSuccessfully() {
        let exp = expectation(description: "It should successfully delete the user.")

        TestObjects.Client.shared.deleteUser(TestObjects.UserIDs.validId) { result in
            self.verifyAPIResultSuccess(result, expectation: exp) { voidValue in
                XCTAssertNotNil(voidValue)
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testItShouldFailToDeleteUserWithEmptyId() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.deleteUser(TestObjects.UserIDs.emptyString) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .userIdCannotBeAnEmptyString)
        }

        waitForExpectations(timeout: 3)
    }

    func testItShouldFailToDeleteUserWithIdThatIsTooLong() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.deleteUser(TestObjects.UserIDs.tooLong) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .userIdInvalid(maxCharacters: 164))
        }

        waitForExpectations(timeout: 3)
    }
}
