//
//  MovieRepositoryTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieRepositoryTests: XCTestCase {

    func testFetchCategoriesReturnsMappedDomainCategories() throws {
        let expectation = expectation(description: "fetch categories")
        let mockDataSource = MockMovieRemoteDataSource()
        mockDataSource.genresToReturn = .success([
            CategoryDTO(id: 28, name: "Acción"),
            CategoryDTO(id: 35, name: "Comedia")
        ])
        let repository = MovieRepository(remoteDataSource: mockDataSource)

        repository.fetchCategories { result in
            switch result {
            case .success(let categories):
                XCTAssertEqual(categories.count, 2)
                XCTAssertEqual(categories[0].id, 28)
                XCTAssertEqual(categories[0].name, "Acción")
                XCTAssertTrue(categories[0].movies.isEmpty)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testFetchCategoriesReturnsErrorOnFailure() throws {
        let expectation = expectation(description: "fetch categories error")
        let mockDataSource = MockMovieRemoteDataSource()
        mockDataSource.genresToReturn = .failure(NSError(domain: "test", code: 500))
        let repository = MovieRepository(remoteDataSource: mockDataSource)

        repository.fetchCategories { result in
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

    func testFetchMoviesReturnsMappedDomainMovies() throws {
        let expectation = expectation(description: "fetch movies")
        let mockDataSource = MockMovieRemoteDataSource()
        mockDataSource.moviesToReturn = [28: .success([
            MovieDTO(id: 1, title: "Die Hard", overview: "Boom", posterPath: "/dh.jpg", voteAverage: 8.0, releaseDate: "1988-07-15")
        ])]
        let repository = MovieRepository(remoteDataSource: mockDataSource)

        repository.fetchMovies(forCategoryId: 28) { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies[0].title, "Die Hard")
                XCTAssertEqual(movies[0].posterPath, "/dh.jpg")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testFetchMoviesReturnsErrorOnFailure() throws {
        let expectation = expectation(description: "fetch movies error")
        let mockDataSource = MockMovieRemoteDataSource()
        mockDataSource.moviesToReturn = [28: .failure(NSError(domain: "test", code: 404))]
        let repository = MovieRepository(remoteDataSource: mockDataSource)

        repository.fetchMovies(forCategoryId: 28) { result in
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

    func testFetchMoviesReturnsEmptyArrayForUnknownCategory() throws {
        let expectation = expectation(description: "empty movies")
        let mockDataSource = MockMovieRemoteDataSource()
        let repository = MovieRepository(remoteDataSource: mockDataSource)

        repository.fetchMovies(forCategoryId: 999) { result in
            switch result {
            case .success(let movies):
                XCTAssertTrue(movies.isEmpty)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testFetchMovieDetailCombinesDetailImagesAndCast() throws {
        let expectation = expectation(description: "fetch movie detail")
        let mockDataSource = MockMovieRemoteDataSource()
        mockDataSource.movieDetailToReturn = .success(MovieDetailDTO(id: 1, title: "Movie", overview: "Overview", voteAverage: 8.5, releaseDate: "2023-01-01"))
        mockDataSource.movieImagesToReturn = .success([MovieImageDTO(filePath: "/img.jpg", width: 780, height: 439)])
        mockDataSource.movieCreditsToReturn = .success([ActorDTO(id: 10, name: "Actor", character: "Hero", profilePath: "/a.jpg")])
        let repository = MovieRepository(remoteDataSource: mockDataSource)

        repository.fetchMovieDetail(movieId: 1) { result in
            switch result {
            case .success(let detail):
                XCTAssertEqual(detail.id, 1)
                XCTAssertEqual(detail.title, "Movie")
                XCTAssertEqual(detail.voteAverage, 8.5)
                XCTAssertEqual(detail.images.count, 1)
                XCTAssertEqual(detail.images[0].filePath, "/img.jpg")
                XCTAssertEqual(detail.cast.count, 1)
                XCTAssertEqual(detail.cast[0].name, "Actor")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testFetchMovieDetailReturnsErrorWhenDetailFetchFails() throws {
        let expectation = expectation(description: "detail error")
        let mockDataSource = MockMovieRemoteDataSource()
        mockDataSource.movieDetailToReturn = .failure(NSError(domain: "test", code: 500))
        mockDataSource.movieImagesToReturn = .success([])
        mockDataSource.movieCreditsToReturn = .success([])
        let repository = MovieRepository(remoteDataSource: mockDataSource)

        repository.fetchMovieDetail(movieId: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure:
                break
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testFetchMovieDetailSucceedsEvenWhenImagesFail() throws {
        let expectation = expectation(description: "detail with images error")
        let mockDataSource = MockMovieRemoteDataSource()
        mockDataSource.movieDetailToReturn = .success(MovieDetailDTO(id: 1, title: "Movie", overview: "Overview", voteAverage: 7.0, releaseDate: "2023-01-01"))
        mockDataSource.movieImagesToReturn = .failure(NSError(domain: "test", code: 404))
        mockDataSource.movieCreditsToReturn = .success([])
        let repository = MovieRepository(remoteDataSource: mockDataSource)

        repository.fetchMovieDetail(movieId: 1) { result in
            switch result {
            case .success(let detail):
                XCTAssertEqual(detail.id, 1)
                XCTAssertEqual(detail.title, "Movie")
            case .failure:
                XCTFail("Expected success when detail succeeds but images fail")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testFetchMovieDetailUsesEmptyStringWhenReleaseDateIsNil() throws {
        let expectation = expectation(description: "nil release date")
        let mockDataSource = MockMovieRemoteDataSource()
        mockDataSource.movieDetailToReturn = .success(MovieDetailDTO(id: 1, title: "Movie", overview: "Overview", voteAverage: 6.0, releaseDate: nil))
        mockDataSource.movieImagesToReturn = .success([])
        mockDataSource.movieCreditsToReturn = .success([])
        let repository = MovieRepository(remoteDataSource: mockDataSource)

        repository.fetchMovieDetail(movieId: 1) { result in
            switch result {
            case .success(let detail):
                XCTAssertEqual(detail.releaseDate, "")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
}
