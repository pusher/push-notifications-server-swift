@testable import PushNotifications
import XCTest

final class InstanceConfigurationTests: XCTestCase {

    func testValidInstance() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let interests = ["pizza", "vegan-pizza"]
        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        let exp = expectation(description: "It should successfully publish to the interests.")

        pushNotifications.publishToInterests(interests, publishRequest) { result in
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
        let instanceId = ""
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let interests = ["pizza", "vegan-pizza"]
        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        let exp = expectation(description: "It should return an error.")

        pushNotifications.publishToInterests(interests, publishRequest) { result in
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
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = ""

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let interests = ["pizza", "vegan-pizza"]
        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        let exp = expectation(description: "It should return an error.")

        pushNotifications.publishToInterests(interests, publishRequest) { result in
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
