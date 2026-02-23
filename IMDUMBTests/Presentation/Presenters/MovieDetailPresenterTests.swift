//
//  MovieDetailPresenterTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class MovieDetailPresenterTests: XCTestCase {

    func testViewDidLoadShowsLoading() throws {
        let mockView = MockMovieDetailView()
        let mockUseCase = MockFetchMovieDetailUseCase()
        mockUseCase.resultToReturn = .success(MovieDetail(id: 1, title: "Movie", overview: "Overview", voteAverage: 8.0, releaseDate: "2023-01-01", images: [], cast: []))
        let presenter = MovieDetailPresenter(view: mockView, movieId: 1, fetchMovieDetailUseCase: mockUseCase)

        presenter.viewDidLoad()

        XCTAssertTrue(mockView.showLoadingCalled)
    }

    func testViewDidLoadFetchesDetailForCorrectMovieId() throws {
        let expectation = expectation(description: "correct movie id")
        let mockView = MockMovieDetailView()
        let mockUseCase = MockFetchMovieDetailUseCase()
        let detail = MovieDetail(id: 42, title: "Movie", overview: "Overview", voteAverage: 8.0, releaseDate: "2023-01-01", images: [], cast: [])
        mockUseCase.resultToReturn = .success(detail)
        let presenter = MovieDetailPresenter(view: mockView, movieId: 42, fetchMovieDetailUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(mockUseCase.receivedMovieId, 42)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadDisplaysMovieDetailOnSuccess() throws {
        let expectation = expectation(description: "display movie detail")
        let mockView = MockMovieDetailView()
        let mockUseCase = MockFetchMovieDetailUseCase()
        let images = [MovieImage(filePath: "/img.jpg", width: 780, height: 439)]
        let cast = [Actor(id: 1, name: "Actor", character: "Hero", profilePath: "/a.jpg")]
        let detail = MovieDetail(id: 1, title: "Great Movie", overview: "Amazing", voteAverage: 9.0, releaseDate: "2023-06-15", images: images, cast: cast)
        mockUseCase.resultToReturn = .success(detail)
        let presenter = MovieDetailPresenter(view: mockView, movieId: 1, fetchMovieDetailUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.displayMovieDetailCalled)
            XCTAssertEqual(mockView.receivedMovieDetail?.id, 1)
            XCTAssertEqual(mockView.receivedMovieDetail?.title, "Great Movie")
            XCTAssertEqual(mockView.receivedMovieDetail?.images.count, 1)
            XCTAssertEqual(mockView.receivedMovieDetail?.cast.count, 1)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadStoresMovieDetailOnSuccess() throws {
        let expectation = expectation(description: "store movie detail")
        let mockView = MockMovieDetailView()
        let mockUseCase = MockFetchMovieDetailUseCase()
        let detail = MovieDetail(id: 1, title: "Movie", overview: "Overview", voteAverage: 7.5, releaseDate: "2023-01-01", images: [], cast: [])
        mockUseCase.resultToReturn = .success(detail)
        let presenter = MovieDetailPresenter(view: mockView, movieId: 1, fetchMovieDetailUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(presenter.movieDetail)
            XCTAssertEqual(presenter.movieDetail?.id, 1)
            XCTAssertEqual(presenter.movieDetail?.voteAverage, 7.5)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadHidesLoadingAfterSuccess() throws {
        let expectation = expectation(description: "hide loading after success")
        let mockView = MockMovieDetailView()
        let mockUseCase = MockFetchMovieDetailUseCase()
        mockUseCase.resultToReturn = .success(MovieDetail(id: 1, title: "Movie", overview: "Overview", voteAverage: 8.0, releaseDate: "2023-01-01", images: [], cast: []))
        let presenter = MovieDetailPresenter(view: mockView, movieId: 1, fetchMovieDetailUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.hideLoadingCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadShowsErrorOnFailure() throws {
        let expectation = expectation(description: "show error on failure")
        let mockView = MockMovieDetailView()
        let mockUseCase = MockFetchMovieDetailUseCase()
        let error = NSError(domain: "test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not found"])
        mockUseCase.resultToReturn = .failure(error)
        let presenter = MovieDetailPresenter(view: mockView, movieId: 999, fetchMovieDetailUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.showErrorCalled)
            XCTAssertEqual(mockView.receivedErrorMessage, "Not found")
            XCTAssertFalse(mockView.displayMovieDetailCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadHidesLoadingAfterFailure() throws {
        let expectation = expectation(description: "hide loading after failure")
        let mockView = MockMovieDetailView()
        let mockUseCase = MockFetchMovieDetailUseCase()
        mockUseCase.resultToReturn = .failure(NSError(domain: "test", code: 500))
        let presenter = MovieDetailPresenter(view: mockView, movieId: 1, fetchMovieDetailUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.hideLoadingCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testMovieDetailIsNilBeforeViewDidLoad() throws {
        let mockView = MockMovieDetailView()
        let mockUseCase = MockFetchMovieDetailUseCase()
        let presenter = MovieDetailPresenter(view: mockView, movieId: 1, fetchMovieDetailUseCase: mockUseCase)

        XCTAssertNil(presenter.movieDetail)
    }

    func testMovieDetailRemainsNilAfterFailure() throws {
        let expectation = expectation(description: "nil after failure")
        let mockView = MockMovieDetailView()
        let mockUseCase = MockFetchMovieDetailUseCase()
        mockUseCase.resultToReturn = .failure(NSError(domain: "test", code: 500))
        let presenter = MovieDetailPresenter(view: mockView, movieId: 1, fetchMovieDetailUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNil(presenter.movieDetail)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }
}
