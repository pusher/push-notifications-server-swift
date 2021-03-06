#if !canImport(ObjectiveC)
import XCTest

extension InstanceConfigurationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__InstanceConfigurationTests = [
        ("testInstanceIdShouldNotBeEmptyString", testInstanceIdShouldNotBeEmptyString),
        ("testSecretKeyShouldNotBeEmptyString", testSecretKeyShouldNotBeEmptyString),
        ("testValidInstance", testValidInstance),
    ]
}

extension InterestsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__InterestsTests = [
        ("testInterestInTheArrayIsTooLong", testInterestInTheArrayIsTooLong),
        ("testInterestsArrayShouldContainMaximumOf100Interests", testInterestsArrayShouldContainMaximumOf100Interests),
        ("testInterestsArrayShouldNotBeEmpty", testInterestsArrayShouldNotBeEmpty),
        ("testInterestsArrayShouldNotContainAnEmptyString", testInterestsArrayShouldNotContainAnEmptyString),
    ]
}

extension TokenTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TokenTests = [
        ("testItShouldAuthenticateTheUserSuccessfully", testItShouldAuthenticateTheUserSuccessfully),
        ("testItShouldFailToGenerateTokenWithEmptyId", testItShouldFailToGenerateTokenWithEmptyId),
        ("testItShouldFailToGenerateTokenWithIdThatIsTooLong", testItShouldFailToGenerateTokenWithIdThatIsTooLong),
    ]
}

extension UsersTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__UsersTests = [
        ("testItShouldDeleteTheUserSuccessfully", testItShouldDeleteTheUserSuccessfully),
        ("testItShouldFailToDeleteUserWithEmptyId", testItShouldFailToDeleteUserWithEmptyId),
        ("testItShouldFailToDeleteUserWithIdThatIsTooLong", testItShouldFailToDeleteUserWithIdThatIsTooLong),
        ("testPublishToMoreThan1000UsersShouldFail", testPublishToMoreThan1000UsersShouldFail),
        ("testPublishToUsersRequiresAtLeastOneUser", testPublishToUsersRequiresAtLeastOneUser),
        ("testPublishToUsersUsernameShouldBeLessThan165Characters", testPublishToUsersUsernameShouldBeLessThan165Characters),
        ("testPublishToUsersUserShouldNotBeAnEmptyString", testPublishToUsersUserShouldNotBeAnEmptyString),
        ("testValidPublishToUsers", testValidPublishToUsers),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(InstanceConfigurationTests.__allTests__InstanceConfigurationTests),
        testCase(InterestsTests.__allTests__InterestsTests),
        testCase(TokenTests.__allTests__TokenTests),
        testCase(UsersTests.__allTests__UsersTests),
    ]
}
#endif
