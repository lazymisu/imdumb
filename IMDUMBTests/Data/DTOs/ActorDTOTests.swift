//
//  ActorDTOTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class ActorDTOTests: XCTestCase {

    func testToDomainMapsAllFieldsIncludingProfilePath() throws {
        let dto = ActorDTO(id: 5, name: "Jane", character: "Villain", profilePath: "/jane.jpg")
        let domain = dto.toDomain()
        XCTAssertEqual(domain.id, 5)
        XCTAssertEqual(domain.name, "Jane")
        XCTAssertEqual(domain.character, "Villain")
        XCTAssertEqual(domain.profilePath, "/jane.jpg")
    }

    func testToDomainHandlesNilProfilePath() throws {
        let dto = ActorDTO(id: 6, name: "Unknown", character: "Extra", profilePath: nil)
        let domain = dto.toDomain()
        XCTAssertNil(domain.profilePath)
    }

    func testDecodesFromJSONWithSnakeCaseKeys() throws {
        let json = """
        {
            "id": 10,
            "name": "Actor Name",
            "character": "Character Name",
            "profile_path": "/actor.jpg"
        }
        """.data(using: .utf8)!
        let dto = try JSONDecoder().decode(ActorDTO.self, from: json)
        XCTAssertEqual(dto.profilePath, "/actor.jpg")
    }

    func testDecodesFromJSONWithNullProfilePath() throws {
        let json = """
        {
            "id": 11,
            "name": "No Photo",
            "character": "Nobody",
            "profile_path": null
        }
        """.data(using: .utf8)!
        let dto = try JSONDecoder().decode(ActorDTO.self, from: json)
        XCTAssertNil(dto.profilePath)
    }
}
