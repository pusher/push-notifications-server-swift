@testable import PushNotifications
import XCTest

final class InterestsTests: XCTestCase {

    // N.B: Testing the success case is covered in InstanceConfigurationTests.testValidInstance()

    func testInterestsArrayShouldNotBeEmpty() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToInterests(TestObjects.Interests.emptyArray,
                                                     TestObjects.Publish.publishRequest) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .interestsArrayCannotBeEmpty)
        }

        waitForExpectations(timeout: 3)
    }

    func testInterestsArrayShouldNotContainAnEmptyString() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToInterests([TestObjects.Interests.emptyString],
                                                     TestObjects.Publish.publishRequest) { result in
            let error = PushNotificationsError.internalError(NetworkService.Error.failedResponse(statusCode: 422))
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: error)
        }

        waitForExpectations(timeout: 3)
    }

    func testInterestsArrayShouldContainMaximumOf100Interests() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToInterests(TestObjects.Interests.tooMany,
                                                     TestObjects.Publish.publishRequest) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .interestsArrayContainsTooManyInterests(maxInterests: 100))
        }

        waitForExpectations(timeout: 3)
    }

    func testInterestInTheArrayIsTooLong() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToInterests(TestObjects.Interests.tooLong,
                                                     TestObjects.Publish.publishRequest) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .interestsArrayContainsAnInvalidInterest(maxCharacters: 164))
        }

        waitForExpectations(timeout: 3)
    }
}
