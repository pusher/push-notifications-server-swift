@testable import PushNotifications
import XCTest

extension XCTestCase {

    /// Verifies that a `Result` contains a specific error.
    ///
    /// This helper method is useful when testing against expected error conditions.
    /// - Parameters:
    ///   - result: A `Result<Success, Failure>` returned from an API request (or similar operation).
    ///             Where `Failure: Error & Equatable`.
    ///   - file: The source file that called the receiver.
    ///   - function: The function that called the receiver.
    ///   - line: The line number of the call site of the receiver.
    ///   - expectation: An `XCTestExpectation` which will be fulfilled after inspecting `result`.
    ///   - expectedError: The `Failure` which is expected to be found inside `result`.
    func verifyResultFailure<Success, Failure>(_ result: Result<Success, Failure>,
                                               file: StaticString = #file,
                                               function: StaticString = #function,
                                               line: UInt = #line,
                                               expectation: XCTestExpectation,
                                               expectedError: Failure) where Failure: Error & Equatable {
        switch result {
        case .success(let value):
            XCTFail("This test should not succeed. Instead found value: \(String(describing: value))",
                    file: file,
                    line: line)

        case .failure(let error):
            XCTAssertEqual(error, expectedError, file: file, line: line)
        }
        expectation.fulfill()
    }

    /// Verifies that a `Result` contains a successful value.
    /// - Parameters:
    ///   - result: A `Result<Success, Failure>` returned from an API request (or similar operation).
    ///             Where `Failure: Error`.
    ///   - file: The source file that called the receiver.
    ///   - function: The function that called the receiver.
    ///   - line: The line number of the call site of the receiver.
    ///   - expectation: An `XCTestExpectation` which will be fulfilled after inspecting `result`.
    ///   - validateResultCallback: A closure executed when `result` contains a decoded value.
    ///                             This can be used to inspect the value and determine its correctness.
    func verifyResultSuccess<Success, Failure>(_ result: Result<Success, Failure>,
                                               file: StaticString = #file,
                                               function: StaticString = #function,
                                               line: UInt = #line,
                                               expectation: XCTestExpectation,
                                               validateResultCallback: (Success) -> Void) where Failure: Error {
        switch result {
        case .success(let value):
            validateResultCallback(value)

        case .failure(let error):
            XCTFail("This test should not fail. Instead found error: \(error.localizedDescription)",
                    file: file,
                    line: line)
        }
        expectation.fulfill()
    }
}

extension XCTestExpectation {

    /// Creates a `XCTestExpectation` with a `description` based on the name of calling function.
    /// - Parameter function: The function that called the receiver.
    convenience init(function: StaticString = #function) {
        let function = String(describing: function).components(separatedBy: "()").first!
        self.init(description: "\(function)Expectation")
    }
}
