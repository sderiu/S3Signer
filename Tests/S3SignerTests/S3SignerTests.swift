import XCTest
@testable import S3Signer

final class S3SignerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(S3Signer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
