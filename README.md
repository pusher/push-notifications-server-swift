# Pusher Beams Swift Server SDK

[![Build Status](https://travis-ci.org/pusher/push-notifications-server-swift.svg?branch=master)](https://travis-ci.org/pusher/push-notifications-server-swift)

## Building the project

`swift build`

## Running the tests

`swift test`

## Installation

To include PushNotifications in your package, add the following to your Package.swift file.

```swift
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "YourProjectName",
    dependencies: [
        ...
        .package(url: "git@github.com:pusher/push-notifications-server-swift.git", from: "1.0.2",
    ],
    targets: [
      .target(name: "YourProjectName", dependencies: ["PushNotifications", ... ])
    ]
)
```

Use `import PushNotifications` to access the APIs.

## Example

```swift
// Pusher Beams Instance Id.
let instanceId = "c7c52433-8c65-43e6-9ef2-922d9ed9e196"
// Pusher Beams Secret Key.
let secretKey = "39817C9BCBF7F053CB151343D54EE75"

// PushNotifications instance.
let pushNotifications = PushNotifications(instanceId: instanceId, secretKey: secretKey)

// Interests array.
let interests = ["pizza", "donuts"]
// Publish request: APNs, FCM.
let publishRequest = [
  "apns": [
    "aps": [
      "alert": "Hello"
    ]
  ],
  "fcm": [
    "notification": [
      "title": "Hello",
      "body":  "Hello, world",
    ]
  ]
]

// Publish To Interests
pushNotifications.publishToInterests(interests, publishRequest, completion: { result in
    switch result {
    case .value(let publishId):
        print("\(publishId)")
    case .error(let error):
        print("\(error)")
    }
})

// Publish To Users
pushNotifications.publishToUsers(["jonathan", "jordan", "luís", "luka", "mina"], publishRequest, completion: { result in
    switch result {
    case .value(let publishId):
        print("\(publishId)")
    case .error(let error):
        print("\(error)")
    }
})

// Authenticate User
pushNotifications.generateToken("Elmo", completion: { result in
    switch result {
    case .value(let jwtToken):
        // 'jwtToken' is a Dictionary<String, String>
        // Example: ["token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhYWEiLCJleHAiOjE"]
        print("\(jwtToken)")
    case .error(let error):
        print("\(error)")
    }
})

// Delete User
pushNotifications.deleteUser("Elmo", completion: { result in
    switch result {
    case .value:
        print("User deleted 👌")
    case .error(let error):
        print("\(error)")
    }
})
```

## Communication

- Found a bug? Please open an [issue](https://github.com/pusher/push-notifications-server-swift/issues).
- Have a feature request. Please open an [issue](https://github.com/pusher/push-notifications-server-swift/issues).
- If you want to contribute, please submit a [pull request](https://github.com/pusher/push-notifications-server-swift/pulls) (preferably with some tests).

## Credits

Beams is owned and maintained by [Pusher](https://pusher.com).

## License

This project is released under the MIT license. See [LICENSE](https://github.com/pusher/push-notifications-server-swift/blob/master/LICENSE) for details.
