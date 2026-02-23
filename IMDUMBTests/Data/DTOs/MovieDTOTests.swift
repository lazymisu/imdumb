//
//  MovieDTOTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieDTOTests: XCTestCase {

    func testToDomainMapsAllFieldsCorrectly() throws {
        let dto = MovieDTO(id: 1, title: "Test", overview: "Overview", posterPath: "/poster.jpg", voteAverage: 7.5, releaseDate: "2023-01-01")
        let domain = dto.toDomain()
        XCTAssertEqual(domain.id, 1)
        XCTAssertEqual(domain.title, "Test")
        XCTAssertEqual(domain.overview, "Overview")
        XCTAssertEqual(domain.posterPath, "/poster.jpg")
        XCTAssertEqual(domain.voteAverage, 7.5)
        XCTAssertEqual(domain.releaseDate, "2023-01-01")
    }

    func testToDomainReturnsEmptyStringWhenReleaseDateIsNil() throws {
        let dto = MovieDTO(id: 1, title: "Test", overview: "Overview", posterPath: nil, voteAverage: 5.0, releaseDate: nil)
        let domain = dto.toDomain()
        XCTAssertEqual(domain.releaseDate, "")
        XCTAssertNil(domain.posterPath)
    }

    func testDecodesFromJSONWithSnakeCaseKeys() throws {
        let json = """
        {
            "id": 42,
            "title": "Movie",
            "overview": "A movie",
            "poster_path": "/img.jpg",
            "vote_average": 6.3,
            "release_date": "2024-05-10"
        }
        """.data(using: .utf8)!
        let dto = try JSONDecoder().decode(MovieDTO.self, from: json)
        XCTAssertEqual(dto.id, 42)
        XCTAssertEqual(dto.posterPath, "/img.jpg")
        XCTAssertEqual(dto.voteAverage, 6.3)
        XCTAssertEqual(dto.releaseDate, "2024-05-10")
    }

    func testDecodesFromJSONWithNullOptionalFields() throws {
        let json = """
        {
            "id": 1,
            "title": "Movie",
            "overview": "Overview",
            "poster_path": null,
            "vote_average": 0.0,
            "release_date": null
        }
        """.data(using: .utf8)!
        let dto = try JSONDecoder().decode(MovieDTO.self, from: json)
        XCTAssertNil(dto.posterPath)
        XCTAssertNil(dto.releaseDate)
    }
}
