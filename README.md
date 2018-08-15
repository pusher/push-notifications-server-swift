# Pusher Beams Swift Server SDK

[![Build Status](https://travis-ci.org/pusher/push-notifications-server-swift.svg?branch=master)](https://travis-ci.org/pusher/push-notifications-server-swift)

## Building the project

`swift build`

## Running the tests

`swift test`

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

// Call the publish method.
try? pushNotifications.publish(interests, publishRequest) { (publishId) in
  print(publishId)
}
```

## Communication

- Found a bug? Please open an [issue](https://github.com/pusher/push-notifications-server-swift/issues).
- Have a feature request. Please open an [issue](https://github.com/pusher/push-notifications-server-swift/issues).
- If you want to contribute, please submit a [pull request](https://github.com/pusher/push-notifications-server-swift/pulls) (preferably with some tests).

## Credits

Beams is owned and maintained by [Pusher](https://pusher.com).

## License

This project is released under the MIT license. See [LICENSE](https://github.com/pusher/push-notifications-server-swift/blob/master/LICENSE) for details.
