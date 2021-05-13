# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/pusher/push-notifications-server-swift/compare/2.0.0...HEAD)

## 2.0.0 - 2021-05-13

### Added

- Several new error cases to `PushNotificationsError` to cover the conditions previously reported by the `.error(String)` case (see: "Removed").
- [API documentation](https://pusher.github.io/push-notifications-server-swift).
- README information badges.

### Changed

- `PushNotificationsError` now conforms to `LocalizedError`.
- The SDK now uses the built-in `Result` type. The `swift-tools-version` in `Package.swift` has been upgraded from 4.0 to 5.0 in order to make this change.
- All `completion` closures that return a `Result` now return `PushNotificationsError` instead of `Error`.
- `JWTPayload` is no longer part of the public API. (This was not actually used by any other public API and was public by mistake).

### Removed

- The `.error(String)` case from `PushNotificationsError`.
- The `publish(_:_:completion:)` method (which had been deprecated in a previous release).
- The custom implementation of `Result` (see: "Changed").
- The `CompletionHandler` typealias. (This has no impact when using the public API).

## 1.0.3 - 2021-02-02

### Fixed

- Resolved compilation errors when deploying to Heroku or using services like Docker.

## 1.0.2 - 2019-04-16

### Fixed

- Beams Token generation format in which we send the `exp` time.

## 1.0.1 - 2019-02-15

### Changed

- Changed the `deleteUser` endpoint from `user_api` to `customer_api`.

## 1.0.0 - 2019-02-06

### Added

- Support for "Authenticated Users" feature: `publishToUsers`, `generateToken` and `deleteUser`.

### Changed

- `publish` renamed to `publishToInterests` (`publish` method deprecated).
