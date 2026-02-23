//
//  MovieDetailDTOTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieDetailDTOTests: XCTestCase {

    func testDecodesMovieDetailFromJSON() throws {
        let json = """
        {
            "id": 100,
            "title": "Detail Movie",
            "overview": "A detailed overview",
            "vote_average": 9.1,
            "release_date": "2023-06-15"
        }
        """.data(using: .utf8)!
        let dto = try JSONDecoder().decode(MovieDetailDTO.self, from: json)
        XCTAssertEqual(dto.id, 100)
        XCTAssertEqual(dto.title, "Detail Movie")
        XCTAssertEqual(dto.voteAverage, 9.1)
        XCTAssertEqual(dto.releaseDate, "2023-06-15")
    }

    func testDecodesMovieDetailWithNullReleaseDate() throws {
        let json = """
        {
            "id": 101,
            "title": "No Date",
            "overview": "Overview",
            "vote_average": 5.0,
            "release_date": null
        }
        """.data(using: .utf8)!
        let dto = try JSONDecoder().decode(MovieDetailDTO.self, from: json)
        XCTAssertNil(dto.releaseDate)
    }
}
