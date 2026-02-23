//
//  MovieImageDTOTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieImageDTOTests: XCTestCase {

    func testToDomainMapsAllFields() throws {
        let dto = MovieImageDTO(filePath: "/backdrop.jpg", width: 1920, height: 1080)
        let domain = dto.toDomain()
        XCTAssertEqual(domain.filePath, "/backdrop.jpg")
        XCTAssertEqual(domain.width, 1920)
        XCTAssertEqual(domain.height, 1080)
    }

    func testDecodesFromJSONWithSnakeCaseKeys() throws {
        let json = """
        {
            "file_path": "/img.jpg",
            "width": 780,
            "height": 439
        }
        """.data(using: .utf8)!
        let dto = try JSONDecoder().decode(MovieImageDTO.self, from: json)
        XCTAssertEqual(dto.filePath, "/img.jpg")
        XCTAssertEqual(dto.width, 780)
    }
}
