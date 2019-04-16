# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/pusher/push-notifications-server-swift/compare/1.0.2...HEAD)

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
