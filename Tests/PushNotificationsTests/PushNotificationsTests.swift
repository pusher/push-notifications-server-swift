import XCTest
@testable import PushNotifications

final class PushNotificationsTests: XCTestCase {

    func testValidInstance() {
        let instanceId = "c7c52433-8c65-43e6-9ef2-922d9ed9e196"
        let secretKey = "39817C9BCBF7F053CB151343D54EE75"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let interests = ["pizza", "vegan-pizza"]
        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        XCTAssertNoThrow(try pushNotifications.publishToInterests(interests, publishRequest) { (_) in })
    }

    func testInstanceIdShouldNotBeEmptyString() {
        let instanceId = ""
        let secretKey = "39817C9BCBF7F053CB151343D54EE75"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let interests = ["pizza", "vegan-pizza"]
        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        XCTAssertThrowsError(try pushNotifications.publishToInterests(interests, publishRequest) { (_) in }) { error in
            guard case PushNotificationsError.instanceIdCannotBeAnEmptyString = error else {
                return XCTFail("It should return instanceIdCannotBeAnEmptyString error.")
            }
        }
    }

    func testSecretKeyShouldNotBeEmptyString() {
        let instanceId = "c7c52433-8c65-43e6-9ef2-922d9ed9e196"
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

        XCTAssertThrowsError(try pushNotifications.publishToInterests(interests, publishRequest) { (_) in }) { error in
            guard case PushNotificationsError.secretKeyCannotBeAnEmptyString = error else {
                return XCTFail("It should return secretKeyCannotBeAnEmptyString error.")
            }
        }
    }

    func testInterestsArrayShouldNotBeEmpty() {
        let instanceId = "c7c52433-8c65-43e6-9ef2-922d9ed9e196"
        let secretKey = "39817C9BCBF7F053CB151343D54EE75"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let interests: [String] = []
        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        XCTAssertThrowsError(try pushNotifications.publishToInterests(interests, publishRequest) { (_) in }) { error in
            guard case PushNotificationsError.interestsArrayCannotBeEmpty = error else {
                return XCTFail("It should return interestsArrayCannotBeEmpty error.")
            }
        }
    }

    func testInterestsArrayShouldContainMaximumOf100Interests() {
        let instanceId = "c7c52433-8c65-43e6-9ef2-922d9ed9e196"
        let secretKey = "39817C9BCBF7F053CB151343D54EE75"

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

        XCTAssertThrowsError(try pushNotifications.publishToInterests(interests, publishRequest) { (_) in }) { error in
            guard case PushNotificationsError.interestsArrayContainsTooManyInterests(let maximumNumberOfInterests) = error else {
                return XCTFail("It should return interestsArrayContainsTooManyInterests error.")
            }

            XCTAssertEqual(maximumNumberOfInterests, 100, "Interests array can contain maximum of 100 interests.")
        }
    }

        func testInterestInTheArrayIsTooLong() {
        let instanceId = "c7c52433-8c65-43e6-9ef2-922d9ed9e196"
        let secretKey = "39817C9BCBF7F053CB151343D54EE75"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let interests = ["kjfioiowejfiofjeijifjwiejifwejiojfiowejifwjiofejifwejiejfiojioewjiofjiowefeewfiniienwvinvinwkjfioiowejfiofjeijifjwiejifwejiojfiowejifwjiofejifwejiejfiojioewjiofjiowefeewfiniienwvinvinw"]
        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        XCTAssertThrowsError(try pushNotifications.publishToInterests(interests, publishRequest) { (_) in }) { error in
            guard case PushNotificationsError.interestsArrayContainsAnInvalidInterest(let maximumInterestCharacterCount) = error else {
                return XCTFail("It should return interestsArrayContainsAnInvalidInterest error.")
            }

            XCTAssertEqual(maximumInterestCharacterCount, 164, "Interest name can be constructed from maximum of 164 characters.")
        }
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
