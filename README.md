# Pusher Beams Swift Server SDK

![Build Status](https://github.com/pusher/push-notifications-server-swift/workflows/CI/badge.svg)
[![Latest Release](https://img.shields.io/github/v/release/pusher/push-notifications-server-swift)](https://github.com/pusher/push-notifications-server-swift/releases)
[![API Docs](https://img.shields.io/badge/Docs-here!-lightgrey)](https://pusher.github.io/push-notifications-server-swift/)
[![Supported Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpusher%2Fpush-notifications-server-swift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/pusher/push-notifications-server-swift)
[![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpusher%2Fpush-notifications-server-swift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/pusher/push-notifications-server-swift)
[![Twitter](https://img.shields.io/badge/twitter-@Pusher-blue.svg?style=flat)](http://twitter.com/Pusher)
[![LICENSE](https://img.shields.io/github/license/pusher/push-notifications-server-swift)](https://github.com/pusher/push-notifications-server-swift/blob/main/LICENSE)

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
        .package(url: "git@github.com:pusher/push-notifications-server-swift.git", from: "1.0.3",
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
    case .success(let publishId):
        print("\(publishId)")
    case .failure(let error):
        print("\(error)")
    }
})

// Publish To Users
pushNotifications.publishToUsers(["jonathan", "jordan", "luís", "luka", "mina"], publishRequest, completion: { result in
    switch result {
    case .success(let publishId):
        print("\(publishId)")
    case .failure(let error):
        print("\(error)")
    }
})

// Authenticate User
pushNotifications.generateToken("Elmo", completion: { result in
    switch result {
    case .success(let jwtToken):
        // 'jwtToken' is a Dictionary<String, String>
        // Example: ["token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhYWEiLCJleHAiOjE"]
        print("\(jwtToken)")
    case .failure(let error):
        print("\(error)")
    }
})

// Delete User
pushNotifications.deleteUser("Elmo", completion: { result in
    switch result {
    case .success:
        print("User deleted 👌")
    case .failure(let error):
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
