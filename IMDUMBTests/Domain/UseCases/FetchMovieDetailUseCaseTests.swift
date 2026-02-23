//
//  FetchMovieDetailUseCaseTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class FetchMovieDetailUseCaseTests: XCTestCase {
    
    func testSuccessfullyFetchesMovieDetail() throws {
        let expectation = expectation(description: "fetch movie detail")
        let mockRepository = MockMovieRepository()
        let detail = MovieDetail(id: 1, title: "Test Movie", overview: "Great movie", voteAverage: 8.5, releaseDate: "2023-01-01", images: [], cast: [])
        mockRepository.movieDetailToReturn = .success(detail)
        
        let useCase = FetchMovieDetailUseCase(repository: mockRepository)
        
        useCase.execute(movieId: 1) { result in
            switch result {
            case .success(let movieDetail):
                XCTAssertEqual(movieDetail.id, 1)
                XCTAssertEqual(movieDetail.title, "Test Movie")
                XCTAssertEqual(movieDetail.voteAverage, 8.5)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testReturnsErrorWhenFetchMovieDetailFails() throws {
        let expectation = expectation(description: "fetch movie detail error")
        let mockRepository = MockMovieRepository()
        let expectedError = NSError(domain: "test", code: 404, userInfo: nil)
        mockRepository.movieDetailToReturn = .failure(expectedError)
        
        let useCase = FetchMovieDetailUseCase(repository: mockRepository)
        
        useCase.execute(movieId: 999) { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertEqual((error as NSError).code, 404)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testFetchesMovieDetailWithImagesAndCast() throws {
        let expectation = expectation(description: "fetch detail with images and cast")
        let mockRepository = MockMovieRepository()
        let images = [MovieImage(filePath: "/img.jpg", width: 780, height: 439)]
        let cast = [Actor(id: 1, name: "Actor", character: "Hero", profilePath: "/profile.jpg")]
        let detail = MovieDetail(id: 1, title: "Test", overview: "Overview", voteAverage: 7.0, releaseDate: "2023-01-01", images: images, cast: cast)
        mockRepository.movieDetailToReturn = .success(detail)
        
        let useCase = FetchMovieDetailUseCase(repository: mockRepository)
        
        useCase.execute(movieId: 1) { result in
            switch result {
            case .success(let movieDetail):
                XCTAssertEqual(movieDetail.images.count, 1)
                XCTAssertEqual(movieDetail.cast.count, 1)
                XCTAssertEqual(movieDetail.cast.first?.name, "Actor")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
}
