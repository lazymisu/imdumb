//
//  MovieCastResponseTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieCastResponseTests: XCTestCase {

    func testDecodesCreditsResponseFromJSON() throws {
        let json = """
        {
            "cast": [
                {"id": 1, "name": "Actor", "character": "Hero", "profile_path": "/a.jpg"},
                {"id": 2, "name": "Actress", "character": "Heroine", "profile_path": null}
            ]
        }
        """.data(using: .utf8)!
        let response = try JSONDecoder().decode(MovieCastResponse.self, from: json)
        XCTAssertEqual(response.cast.count, 2)
        XCTAssertEqual(response.cast[0].name, "Actor")
        XCTAssertNil(response.cast[1].profilePath)
    }
}
