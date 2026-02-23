//
//  FetchCategoriesUseCaseTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class FetchCategoriesUseCaseTests: XCTestCase {
    
    func testSuccessfullyFetchesCategoriesWithMovies() throws {
        let expectation = expectation(description: "fetch categories")
        let mockRepository = MockMovieRepository()
        let categories = [
            Category(id: 1, name: "Action", movies: []),
            Category(id: 2, name: "Comedy", movies: [])
        ]
        let actionMovies = [Movie(id: 10, title: "Die Hard", overview: "Boom", posterPath: nil, voteAverage: 8.0, releaseDate: "1988-07-15")]
        let comedyMovies = [Movie(id: 20, title: "The Hangover", overview: "Funny", posterPath: nil, voteAverage: 7.0, releaseDate: "2009-06-05")]
        
        mockRepository.categoriesToReturn = .success(categories)
        mockRepository.moviesToReturn = [1: .success(actionMovies), 2: .success(comedyMovies)]
        
        let useCase = FetchCategoriesUseCase(repository: mockRepository)
        
        useCase.execute { result in
            switch result {
            case .success(let fetchedCategories):
                XCTAssertEqual(fetchedCategories.count, 2)
                XCTAssertEqual(fetchedCategories[0].id, 1)
                XCTAssertEqual(fetchedCategories[0].movies.count, 1)
                XCTAssertEqual(fetchedCategories[0].movies.first?.title, "Die Hard")
                XCTAssertEqual(fetchedCategories[1].id, 2)
                XCTAssertEqual(fetchedCategories[1].movies.first?.title, "The Hangover")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testReturnsErrorWhenFetchCategoriesFails() throws {
        let expectation = expectation(description: "fetch categories error")
        let mockRepository = MockMovieRepository()
        let expectedError = NSError(domain: "test", code: 404, userInfo: nil)
        mockRepository.categoriesToReturn = .failure(expectedError)
        
        let useCase = FetchCategoriesUseCase(repository: mockRepository)
        
        useCase.execute { result in
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
    
    func testReturnsErrorWhenFetchMoviesForAnyCategoryFails() throws {
        let expectation = expectation(description: "fetch movies error")
        let mockRepository = MockMovieRepository()
        let categories = [
            Category(id: 1, name: "Action", movies: []),
            Category(id: 2, name: "Comedy", movies: [])
        ]
        let moviesError = NSError(domain: "test", code: 500, userInfo: nil)
        
        mockRepository.categoriesToReturn = .success(categories)
        mockRepository.moviesToReturn = [
            1: .success([Movie(id: 10, title: "Movie", overview: "Overview", posterPath: nil, voteAverage: 5.0, releaseDate: "2023-01-01")]),
            2: .failure(moviesError)
        ]
        
        let useCase = FetchCategoriesUseCase(repository: mockRepository)
        
        useCase.execute { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertEqual((error as NSError).code, 500)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testReturnsEmptyArrayWhenNoCategoriesExist() throws {
        let expectation = expectation(description: "empty categories")
        let mockRepository = MockMovieRepository()
        mockRepository.categoriesToReturn = .success([])
        
        let useCase = FetchCategoriesUseCase(repository: mockRepository)
        
        useCase.execute { result in
            switch result {
            case .success(let categories):
                XCTAssertTrue(categories.isEmpty)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testReturnsCategoriesSortedById() throws {
        let expectation = expectation(description: "sorted categories")
        let mockRepository = MockMovieRepository()
        let categories = [
            Category(id: 3, name: "Horror", movies: []),
            Category(id: 1, name: "Action", movies: []),
            Category(id: 2, name: "Comedy", movies: [])
        ]
        
        mockRepository.categoriesToReturn = .success(categories)
        
        let useCase = FetchCategoriesUseCase(repository: mockRepository)
        
        useCase.execute { result in
            switch result {
            case .success(let fetchedCategories):
                XCTAssertEqual(fetchedCategories.map { $0.id }, [1, 2, 3])
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
}
