//
//  MovieTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieTests: XCTestCase {
    
    func testPosterURLReturnsValidURLWhenPosterPathIsPresent() throws {
        let movie = Movie(id: 1, title: "Test", overview: "Overview", posterPath: "/abc.jpg", voteAverage: 8.0, releaseDate: "2023-01-01")
        XCTAssertEqual(movie.posterURL, URL(string: "https://image.tmdb.org/t/p/w500/abc.jpg"))
    }
    
    func testPosterURLReturnsNilWhenPosterPathIsNil() throws {
        let movie = Movie(id: 1, title: "Test", overview: "Overview", posterPath: nil, voteAverage: 8.0, releaseDate: "2023-01-01")
        XCTAssertNil(movie.posterURL)
    }
    
    func testMoviesWithSamePropertiesAreEqual() throws {
        let movie1 = Movie(id: 1, title: "Test", overview: "Overview", posterPath: "/abc.jpg", voteAverage: 8.0, releaseDate: "2023-01-01")
        let movie2 = Movie(id: 1, title: "Test", overview: "Overview", posterPath: "/abc.jpg", voteAverage: 8.0, releaseDate: "2023-01-01")
        XCTAssertEqual(movie1, movie2)
    }
    
    func testMoviesWithDifferentPropertiesAreNotEqual() throws {
        let movie1 = Movie(id: 1, title: "Test", overview: "Overview", posterPath: "/abc.jpg", voteAverage: 8.0, releaseDate: "2023-01-01")
        let movie2 = Movie(id: 2, title: "Other", overview: "Other", posterPath: "/def.jpg", voteAverage: 5.0, releaseDate: "2024-01-01")
        XCTAssertNotEqual(movie1, movie2)
    }
}
