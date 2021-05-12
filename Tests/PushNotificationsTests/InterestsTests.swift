@testable import PushNotifications
import XCTest

final class InterestsTests: XCTestCase {

    func testInterestsArrayShouldNotBeEmpty() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let interests: [String] = []
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
            case .value:
                XCTFail("Result should not contain a value.")

            case .error(let error):
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testInterestsArrayShouldContainMaximumOf100Interests() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f56446"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        var interests: [String] = []

        for _ in 0...100 {
            interests.append("Interest")
        }

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
            case .value:
                XCTFail("Result should not contain a value.")

            case .error(let error):
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testInterestInTheArrayIsTooLong() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let interests = ["""
        kjfioiowejfiofjeijifjwiejifwejiojfiowejifwjiofejifwejiejfiojioewjiofjiowefeewfinii\
        enwvinvinwkjfioiowejfiofjeijifjwiejifwejiojfiowejifwjiofejifwejiejfiojioewjiofjiow\
        efeewfiniienwvinvinw
        """]
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
            case .value:
                XCTFail("Result should not contain a value.")

            case .error(let error):
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 3)
    }
}
