//
//  MovieListResponseTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieListResponseTests: XCTestCase {

    func testDecodesMovieListFromJSON() throws {
        let json = """
        {
            "results": [
                {
                    "id": 1,
                    "title": "Movie One",
                    "overview": "Overview one",
                    "poster_path": "/one.jpg",
                    "vote_average": 8.0,
                    "release_date": "2023-01-01"
                }
            ]
        }
        """.data(using: .utf8)!
        let response = try JSONDecoder().decode(MovieListResponse.self, from: json)
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results[0].title, "Movie One")
    }
}
