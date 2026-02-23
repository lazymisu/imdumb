//
//  RemoteConfigRepositoryTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class RemoteConfigRepositoryTests: XCTestCase {

    func testFetchRemoteConfigReturnsConfigDictionary() throws {
        let expectation = expectation(description: "fetch config")
        let mockDataSource = MockFirebaseRemoteConfigDataSource()
        mockDataSource.configToReturn = .success(["welcome_message": "Hola", "feature_enabled": "true"])
        let repository = RemoteConfigRepository(remoteDataSource: mockDataSource)

        repository.fetchRemoteConfig { result in
            switch result {
            case .success(let config):
                XCTAssertEqual(config["welcome_message"], "Hola")
                XCTAssertEqual(config["feature_enabled"], "true")
                XCTAssertEqual(config.count, 2)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testFetchRemoteConfigReturnsErrorOnFailure() throws {
        let expectation = expectation(description: "fetch config error")
        let mockDataSource = MockFirebaseRemoteConfigDataSource()
        mockDataSource.configToReturn = .failure(NSError(domain: "RemoteConfig", code: -1))
        let repository = RemoteConfigRepository(remoteDataSource: mockDataSource)

        repository.fetchRemoteConfig { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertEqual((error as NSError).code, -1)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testFetchRemoteConfigReturnsEmptyDictionary() throws {
        let expectation = expectation(description: "empty config")
        let mockDataSource = MockFirebaseRemoteConfigDataSource()
        mockDataSource.configToReturn = .success([:])
        let repository = RemoteConfigRepository(remoteDataSource: mockDataSource)

        repository.fetchRemoteConfig { result in
            switch result {
            case .success(let config):
                XCTAssertTrue(config.isEmpty)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
}
