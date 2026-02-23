//
//  ActorTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class ActorTests: XCTestCase {
    
    func testProfileURLReturnsValidURLWhenProfilePathIsPresent() throws {
        let actor = Actor(id: 1, name: "John", character: "Hero", profilePath: "/profile.jpg")
        XCTAssertEqual(actor.profileURL, URL(string: "https://image.tmdb.org/t/p/w185/profile.jpg"))
    }
    
    func testProfileURLReturnsNilWhenProfilePathIsNil() throws {
        let actor = Actor(id: 1, name: "John", character: "Hero", profilePath: nil)
        XCTAssertNil(actor.profileURL)
    }
}
