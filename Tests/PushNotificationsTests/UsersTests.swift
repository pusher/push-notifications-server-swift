@testable import PushNotifications
import XCTest

final class UsersTests: XCTestCase {

    func testValidPublishToUsers() {
        let exp = expectation(description: "It should successfully publish to users.")

        TestObjects.Client.shared.publishToUsers(TestObjects.UserIDs.validArray,
                                                 TestObjects.Publish.publishRequest) { result in
            switch result {
            case .success(let publishId):
                XCTAssertNotNil(publishId)
                exp.fulfill()

            case .failure:
                XCTFail("Result should not contain an error.")
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testPublishToUsersRequiresAtLeastOneUser() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToUsers(TestObjects.UserIDs.emptyArray,
                                                 TestObjects.Publish.publishRequest) { result in
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

    func testPublishToUsersUserShouldNotBeAnEmptyString() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToUsers([TestObjects.UserIDs.emptyString],
                                                 TestObjects.Publish.publishRequest) { result in
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

    func testPublishToUsersUsernameShouldBeLessThan165Characters() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToUsers([TestObjects.UserIDs.tooLong],
                                                 TestObjects.Publish.publishRequest) { result in
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

    func testPublishToMoreThan1000UsersShouldFail() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToUsers(TestObjects.UserIDs.tooMany,
                                                 TestObjects.Publish.publishRequest) { result in
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

    func testItShouldDeleteTheUserSuccessfully() {
        let exp = expectation(description: "It should successfully delete the user.")

        TestObjects.Client.shared.deleteUser(TestObjects.UserIDs.validId) { result in
            switch result {
            case .success:
                exp.fulfill()

            case .failure:
                XCTFail("Result should not contain an error.")
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testItShouldFailToDeleteUserWithEmptyId() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.deleteUser(TestObjects.UserIDs.emptyString) { result in
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

    func testItShouldFailToDeleteUserWithIdThatIsTooLong() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.deleteUser(TestObjects.UserIDs.tooLong) { result in
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
