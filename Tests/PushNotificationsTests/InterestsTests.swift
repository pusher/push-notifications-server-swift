@testable import PushNotifications
import XCTest

final class InterestsTests: XCTestCase {

    // N.B: Testing the success case is covered in InstanceConfigurationTests.testValidInstance()

    func testInterestsArrayShouldNotBeEmpty() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToInterests(TestObjects.Interests.emptyArray,
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

    func testInterestsArrayShouldNotContainAnEmptyString() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToInterests([TestObjects.Interests.emptyString],
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

    func testInterestsArrayShouldContainMaximumOf100Interests() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToInterests(TestObjects.Interests.tooMany,
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

    func testInterestInTheArrayIsTooLong() {
        let exp = expectation(description: "It should return an error.")

        TestObjects.Client.shared.publishToInterests(TestObjects.Interests.tooLong,
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
