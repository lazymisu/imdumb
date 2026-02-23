//
//  MovieDetailTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieDetailTests: XCTestCase {
    
    func testFormattedRatingReturnsOneDecimalPlace() throws {
        let detail = MovieDetail(id: 1, title: "Test", overview: "Overview", voteAverage: 8.567, releaseDate: "2023-01-01", images: [], cast: [])
        XCTAssertEqual(detail.formattedRating, "8.6")
    }
    
    func testFormattedRatingReturnsZeroPointZeroForZeroRating() throws {
        let detail = MovieDetail(id: 1, title: "Test", overview: "Overview", voteAverage: 0.0, releaseDate: "2023-01-01", images: [], cast: [])
        XCTAssertEqual(detail.formattedRating, "0.0")
    }
    
    func testFormattedRatingReturnsTenPointZeroForPerfectScore() throws {
        let detail = MovieDetail(id: 1, title: "Test", overview: "Overview", voteAverage: 10.0, releaseDate: "2023-01-01", images: [], cast: [])
        XCTAssertEqual(detail.formattedRating, "10.0")
    }
    
    func testOverviewHTMLReturnsAttributedStringForValidOverview() throws {
        let detail = MovieDetail(id: 1, title: "Test", overview: "A great movie", voteAverage: 8.0, releaseDate: "2023-01-01", images: [], cast: [])
        XCTAssertNotNil(detail.overviewHTML)
    }
    
    func testOverviewHTMLContainsOverviewText() throws {
        let detail = MovieDetail(id: 1, title: "Test", overview: "A great movie", voteAverage: 8.0, releaseDate: "2023-01-01", images: [], cast: [])
        let attributedString = detail.overviewHTML
        XCTAssertTrue(attributedString?.string.contains("A great movie") ?? false)
    }
}
