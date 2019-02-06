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

    func testValidPublishToUsers() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        let exp = expectation(description: "It should successfully publish to users.")

        pushNotifications.publishToUsers(["jonathan", "jordan", "luís", "luka", "mina"], publishRequest, completion: { result in
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

    func testPublishToUsersRequiresAtLeastOneUser() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        let exp = expectation(description: "It should return an error.")

        pushNotifications.publishToUsers([], publishRequest, completion: { result in
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

    func testPublishToUsersUserShouldNotBeAnEmptyString() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        let exp = expectation(description: "It should return an error.")

        pushNotifications.publishToUsers([""], publishRequest, completion: { result in
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

    func testPublishToUsersUsernameShouldBeLessThan165Characters() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]

        let exp = expectation(description: "It should return an error.")

        pushNotifications.publishToUsers(["askdsakdjlksajkldjkajdksjkdjkjkjdkajksjkljkajkdsjkajkdjkoiwqjijiofiowenfioneiveniownvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoin"], publishRequest, completion: { result in
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

    func testPublishToMoreThan1000UsersShouldFail() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": "hi"
                ]
            ]
        ]
        
        var users: [String] = []

        for _ in 0...1000 {
            users.append("a")
        }

        let exp = expectation(description: "It should return an error.")

        pushNotifications.publishToUsers(users, publishRequest, completion: { result in
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

    func testItShouldAuthenticateTheUserSuccessfully() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)
    
        let exp = expectation(description: "It should successfully authenticate the user.")

        pushNotifications.generateToken("aaa", completion: { result in
            switch result {
            case .value(let jwtToken):
                // 'jwtToken' is a Dictionary<String, String>
                // Example: ["token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhYWEiLCJleHAiOjE"]
                XCTAssertNotNil(jwtToken)
                exp.fulfill()
            case .error:
                XCTFail()
            }
        })

        waitForExpectations(timeout: 3)
    }

    func testItShouldFailToGenerateTokenWithEmptyId() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)
    
        let exp = expectation(description: "It should return an error.")

        pushNotifications.generateToken("", completion: { result in
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

    func testItShouldFailToGenerateTokenWithIdThatIsTooLong() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)
    
        let exp = expectation(description: "It should return an error.")

        pushNotifications.generateToken("askdsakdjlksajkldjkajdksjkdjkjkjdkajksjkljkajkdsjkajkdjkoiwqjijiofiowenfioneiveniownvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoin", completion: { result in
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

    func testItShouldDeleteTheUserSuccessfully() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)
    
        let exp = expectation(description: "It should successfully delete the user.")

        pushNotifications.deleteUser("aaa", completion: { result in
            switch result {
            case .value:
                exp.fulfill()
            case .error:
                XCTFail()
            }
        })

        waitForExpectations(timeout: 3)
    }

    func testItShouldFailToDeleteUserWithEmptyId() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)
    
        let exp = expectation(description: "It should return an error.")

        pushNotifications.deleteUser("", completion: { result in
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

    func testItShouldFailToDeleteUserWithIdThatIsTooLong() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)
    
        let exp = expectation(description: "It should return an error.")

        pushNotifications.deleteUser("askdsakdjlksajkldjkajdksjkdjkjkjdkajksjkljkajkdsjkajkdjkoiwqjijiofiowenfioneiveniownvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoin", completion: { result in
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
        ("testInterestInTheArrayIsTooLong", testInterestInTheArrayIsTooLong),
        ("testValidPublishToUsers", testValidPublishToUsers),
        ("testPublishToUsersRequiresAtLeastOneUser", testPublishToUsersRequiresAtLeastOneUser),
        ("testPublishToUsersUserShouldNotBeAnEmptyString", testPublishToUsersUserShouldNotBeAnEmptyString),
        ("testPublishToUsersUsernameShouldBeLessThan165Characters", testPublishToUsersUsernameShouldBeLessThan165Characters),
        ("testPublishToMoreThan1000UsersShouldFail", testPublishToMoreThan1000UsersShouldFail),
        ("testItShouldAuthenticateTheUserSuccessfully", testItShouldAuthenticateTheUserSuccessfully),
        ("testItShouldFailToGenerateTokenWithEmptyId", testItShouldFailToGenerateTokenWithEmptyId),
        ("testItShouldFailToGenerateTokenWithIdThatIsTooLong", testItShouldFailToGenerateTokenWithIdThatIsTooLong),
        ("testItShouldDeleteTheUserSuccessfully", testItShouldDeleteTheUserSuccessfully),
        ("testItShouldFailToDeleteUserWithEmptyId", testItShouldFailToDeleteUserWithEmptyId),
        ("testItShouldFailToDeleteUserWithIdThatIsTooLong", testItShouldFailToDeleteUserWithIdThatIsTooLong)
    ]
}
