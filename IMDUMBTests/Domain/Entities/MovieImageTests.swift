//
//  MovieImageTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieImageTests: XCTestCase {
    
    func testImageURLReturnsValidURL() throws {
        let image = MovieImage(filePath: "/image.jpg", width: 780, height: 439)
        XCTAssertEqual(image.imageURL, URL(string: "https://image.tmdb.org/t/p/w780/image.jpg"))
    }
}
