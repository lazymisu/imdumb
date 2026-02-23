//
//  MovieImagesResponseTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieImagesResponseTests: XCTestCase {

    func testDecodesImagesResponseFromJSON() throws {
        let json = """
        {
            "backdrops": [{"file_path": "/bd.jpg", "width": 1920, "height": 1080}],
            "posters": [{"file_path": "/ps.jpg", "width": 500, "height": 750}]
        }
        """.data(using: .utf8)!
        let response = try JSONDecoder().decode(MovieImagesResponse.self, from: json)
        XCTAssertEqual(response.backdrops.count, 1)
        XCTAssertEqual(response.posters.count, 1)
        XCTAssertEqual(response.backdrops[0].filePath, "/bd.jpg")
    }
}
