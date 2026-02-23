//
//  GenreListResponseTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class GenreListResponseTests: XCTestCase {

    func testDecodesGenreListFromJSON() throws {
        let json = """
        {
            "genres": [
                {"id": 28, "name": "Acción"},
                {"id": 35, "name": "Comedia"}
            ]
        }
        """.data(using: .utf8)!
        let response = try JSONDecoder().decode(GenreListResponse.self, from: json)
        XCTAssertEqual(response.genres.count, 2)
        XCTAssertEqual(response.genres[0].id, 28)
        XCTAssertEqual(response.genres[1].name, "Comedia")
    }

    func testDecodesEmptyGenreList() throws {
        let json = """
        {"genres": []}
        """.data(using: .utf8)!
        let response = try JSONDecoder().decode(GenreListResponse.self, from: json)
        XCTAssertTrue(response.genres.isEmpty)
    }
}
