//
//  APIErrorTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class APIErrorTests: XCTestCase {

    func testInvalidResponseErrorDescriptionIsCorrect() throws {
        let error = APIError.invalidResponse
        XCTAssertEqual(error.errorDescription, "Invalid response from server")
    }

    func testNetworkErrorDescriptionContainsMessage() throws {
        let error = APIError.networkError("timeout")
        XCTAssertEqual(error.errorDescription, "Network error: timeout")
    }

    func testDecodingErrorDescriptionContainsMessage() throws {
        let error = APIError.decodingError("missing key")
        XCTAssertEqual(error.errorDescription, "Decoding error: missing key")
    }

    func testNetworkErrorWithEmptyMessage() throws {
        let error = APIError.networkError("")
        XCTAssertEqual(error.errorDescription, "Network error: ")
    }

    func testDecodingErrorWithEmptyMessage() throws {
        let error = APIError.decodingError("")
        XCTAssertEqual(error.errorDescription, "Decoding error: ")
    }
}
