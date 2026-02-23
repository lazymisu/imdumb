//
//  CategoryTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class CategoryTests: XCTestCase {
    
    func testCategoryCanHoldMovies() throws {
        let movies = [Movie(id: 1, title: "Movie1", overview: "Overview", posterPath: nil, voteAverage: 7.0, releaseDate: "2023-01-01")]
        let category = Category(id: 1, name: "Action", movies: movies)
        XCTAssertEqual(category.movies.count, 1)
        XCTAssertEqual(category.movies.first?.title, "Movie1")
    }
    
    func testCategoryCanBeCreatedWithEmptyMovies() throws {
        let category = Category(id: 1, name: "Action", movies: [])
        XCTAssertTrue(category.movies.isEmpty)
    }
}
