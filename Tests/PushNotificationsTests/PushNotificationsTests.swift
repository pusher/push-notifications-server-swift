import XCTest
@testable import PushNotifications

final class PushNotificationsTests: XCTestCase {

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

        pushNotifications.publishToInterests(interests, publishRequest, completion: { result in
            switch result {
            case .value(let publishId):
                XCTAssertNotNil(publishId)
                exp.fulfill()
            case .error:
                XCTFail()
            }
        })

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

        pushNotifications.publishToInterests(interests, publishRequest, completion: { result in
            switch result {
            case .value:
                XCTFail()
            case .error(let error):
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        })

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

        pushNotifications.publishToInterests(interests, publishRequest, completion: { result in
            switch result {
            case .value:
                XCTFail()
            case .error(let error):
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        })

        waitForExpectations(timeout: 3)
    }

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

        pushNotifications.publishToInterests(interests, publishRequest, completion: { result in
            switch result {
            case .value:
                XCTFail()
            case .error(let error):
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        })

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

        pushNotifications.publishToInterests(interests, publishRequest, completion: { result in
            switch result {
            case .value:
                XCTFail()
            case .error(let error):
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        })

        waitForExpectations(timeout: 3)
    }

        func testInterestInTheArrayIsTooLong() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let interests = ["kjfioiowejfiofjeijifjwiejifwejiojfiowejifwjiofejifwejiejfiojioewjiofjiowefeewfiniienwvinvinwkjfioiowejfiofjeijifjwiejifwejiojfiowejifwjiofejifwejiejfiojioewjiofjiowefeewfiniienwvinvinw"]
        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        let exp = expectation(description: "It should return an error.")

        pushNotifications.publishToInterests(interests, publishRequest, completion: { result in
            switch result {
            case .value:
                XCTFail()
            case .error(let error):
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        })

        waitForExpectations(timeout: 3)
    }

    static var allTests = [
        ("testValidInstance", testValidInstance),
        ("testInstanceIdShouldNotBeEmptyString", testInstanceIdShouldNotBeEmptyString),
        ("testSecretKeyShouldNotBeEmptyString", testSecretKeyShouldNotBeEmptyString),
        ("testInterestsArrayShouldNotBeEmpty", testInterestsArrayShouldNotBeEmpty),
        ("testInterestsArrayShouldContainMaximumOf100Interests", testInterestsArrayShouldContainMaximumOf100Interests),
        ("testInterestInTheArrayIsTooLong", testInterestInTheArrayIsTooLong)
    ]
}
