@testable import PushNotifications
import XCTest

final class InstanceConfigurationTests: XCTestCase {

    func testValidInstance() {
        let exp = expectation(description: "It should successfully publish to the interests.")

        TestObjects.Client.shared.publishToInterests(TestObjects.Interests.validArray,
                                                     TestObjects.Publish.publishRequest) { result in
            self.verifyAPIResultSuccess(result, expectation: exp) { publishId in
                XCTAssertNotNil(publishId)
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testInstanceIdShouldNotBeEmptyString() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.emptyInstanceId.publishToInterests(TestObjects.Interests.validArray,
                                                              TestObjects.Publish.publishRequest) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .instanceIdCannotBeAnEmptyString)
        }

        waitForExpectations(timeout: 3)
    }

    func testSecretKeyShouldNotBeEmptyString() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.emptySecretKey.publishToInterests(TestObjects.Interests.validArray,
                                                             TestObjects.Publish.publishRequest) { result in
            self.verifyAPIResultFailure(result,
                                        expectation: exp,
                                        expectedError: .secretKeyCannotBeAnEmptyString)
        }

        waitForExpectations(timeout: 3)
    }
}
