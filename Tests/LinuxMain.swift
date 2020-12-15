import XCTest

import S3SignerTests

var tests = [XCTestCaseEntry]()
tests += S3SignerTests.allTests()
XCTMain(tests)
