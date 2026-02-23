//
//  CategoryDTOTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class CategoryDTOTests: XCTestCase {

    func testToDomainMapsCategoryDTOToCategory() throws {
        let dto = CategoryDTO(id: 28, name: "Action")
        let domain = dto.toDomain()
        XCTAssertEqual(domain.id, 28)
        XCTAssertEqual(domain.name, "Action")
        XCTAssertTrue(domain.movies.isEmpty)
    }
}
