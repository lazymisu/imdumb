//
//  FetchRemoteConfigUseCaseTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class FetchRemoteConfigUseCaseTests: XCTestCase {
    
    func testSuccessfullyFetchesRemoteConfig() throws {
        let expectation = expectation(description: "fetch remote config")
        let mockRepository = MockRemoteConfigRepository()
        mockRepository.configToReturn = .success(["key1": "value1", "key2": "value2"])
        
        let useCase = FetchRemoteConfigUseCase(repository: mockRepository)
        
        useCase.execute { result in
            switch result {
            case .success(let config):
                XCTAssertEqual(config["key1"], "value1")
                XCTAssertEqual(config["key2"], "value2")
                XCTAssertEqual(config.count, 2)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testReturnsErrorWhenFetchRemoteConfigFails() throws {
        let expectation = expectation(description: "fetch remote config error")
        let mockRepository = MockRemoteConfigRepository()
        let expectedError = NSError(domain: "test", code: 503, userInfo: nil)
        mockRepository.configToReturn = .failure(expectedError)
        
        let useCase = FetchRemoteConfigUseCase(repository: mockRepository)
        
        useCase.execute { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertEqual((error as NSError).code, 503)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testReturnsEmptyDictionaryWhenNoConfigExists() throws {
        let expectation = expectation(description: "empty remote config")
        let mockRepository = MockRemoteConfigRepository()
        mockRepository.configToReturn = .success([:])
        
        let useCase = FetchRemoteConfigUseCase(repository: mockRepository)
        
        useCase.execute { result in
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
