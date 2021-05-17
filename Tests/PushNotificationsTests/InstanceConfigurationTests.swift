@testable import PushNotifications
import XCTest

final class InstanceConfigurationTests: XCTestCase {

    func testValidInstance() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.shared.publishToInterests(TestObjects.Interests.validArray,
                                                     TestObjects.Publish.publishRequest) { result in
            self.verifyResultSuccess(result, expectation: exp) { publishId in
                XCTAssertNotNil(publishId)
            }
        }

        wait(for: [exp], timeout: 3)
    }

    func testInstanceIdShouldNotBeEmptyString() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.emptyInstanceId.publishToInterests(TestObjects.Interests.validArray,
                                                              TestObjects.Publish.publishRequest) { result in
            self.verifyResultFailure(result,
                                     expectation: exp,
                                     expectedError: .instanceIdCannotBeAnEmptyString)
        }

        wait(for: [exp], timeout: 3)
    }

    func testSecretKeyShouldNotBeEmptyString() {
        let exp = XCTestExpectation(function: #function)

        TestObjects.Client.emptySecretKey.publishToInterests(TestObjects.Interests.validArray,
                                                             TestObjects.Publish.publishRequest) { result in
            self.verifyResultFailure(result,
                                     expectation: exp,
                                     expectedError: .secretKeyCannotBeAnEmptyString)
        }

        wait(for: [exp], timeout: 3)
    }
}
