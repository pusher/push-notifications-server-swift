@testable import PushNotifications
import XCTest

final class UsersTests: XCTestCase {

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

        pushNotifications.publishToUsers(["jonathan",
                                          "jordan",
                                          "luís",
                                          "luka",
                                          "mina"],
                                         publishRequest) { result in
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

        pushNotifications.publishToUsers([], publishRequest) { result in
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

        pushNotifications.publishToUsers([""], publishRequest) { result in
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

        pushNotifications.publishToUsers(["""
        askdsakdjlksajkldjkajdksjkdjkjkjdkajksjkljkajkdsjkajkdjkoiwqjijiofiowenfioneivenio\
        wnvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwi\
        nvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinvioenioniwenvioiwni\
        veiniowenviwniwvnienoin
        """], publishRequest) { result in
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

        pushNotifications.publishToUsers(users, publishRequest) { result in
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

    func testItShouldDeleteTheUserSuccessfully() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let exp = expectation(description: "It should successfully delete the user.")

        pushNotifications.deleteUser("aaa") { result in
            switch result {
            case .success:
                exp.fulfill()

            case .failure:
                XCTFail("Result should not contain an error.")
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testItShouldFailToDeleteUserWithEmptyId() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let exp = expectation(description: "It should return an error.")

        pushNotifications.deleteUser("") { result in
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

    func testItShouldFailToDeleteUserWithIdThatIsTooLong() {
        let instanceId = "1b880590-6301-4bb5-b34f-45db1c5f5644"
        let secretKey = "F8AC0B756E50DF235F642D6F0DC2CDE0328CD9184B3874C5E91AB2189BB722FE"

        let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

        let exp = expectation(description: "It should return an error.")

        pushNotifications.deleteUser("""
        askdsakdjlksajkldjkajdksjkdjkjkjdkajksjkljkajkdsjkajkdjkoiwqjijiofiowenfioneiveni\
        ownvionioeniovnioenwinvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioen\
        winvioenioniwenvioiwniveiniowenviwniwvnienoiwnvionioeniovnioenwinvioenioniwenvioi\
        wniveiniowenviwniwvnienoin
        """) { result in
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
