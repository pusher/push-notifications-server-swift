@testable import PushNotifications
import XCTest

final class InstanceConfigurationTests: XCTestCase {

    func testValidInstance() {
        let exp = expectation(description: "It should successfully publish to the interests.")

        TestObjects.Client.shared.publishToInterests(TestObjects.Interests.validArray,
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

    func testInstanceIdShouldNotBeEmptyString() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.emptyInstanceId.publishToInterests(TestObjects.Interests.validArray,
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

    func testSecretKeyShouldNotBeEmptyString() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.emptySecretKey.publishToInterests(TestObjects.Interests.validArray,
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
}
