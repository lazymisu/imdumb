//
//  HomePresenterTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class HomePresenterTests: XCTestCase {

    func testViewDidLoadShowsLoadingBeforeFetching() throws {
        let mockView = MockHomeView()
        let mockUseCase = MockFetchCategoriesUseCase()
        mockUseCase.resultToReturn = .success([])
        let presenter = HomePresenter(view: mockView, fetchCategoriesUseCase: mockUseCase)

        presenter.viewDidLoad()

        XCTAssertTrue(mockView.showLoadingCalled)
    }

    func testViewDidLoadHidesLoadingAfterSuccessfulFetch() throws {
        let expectation = expectation(description: "hide loading after success")
        let mockView = MockHomeView()
        let mockUseCase = MockFetchCategoriesUseCase()
        mockUseCase.resultToReturn = .success([])
        let presenter = HomePresenter(view: mockView, fetchCategoriesUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.hideLoadingCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadShowsCategoriesOnSuccess() throws {
        let expectation = expectation(description: "show categories")
        let mockView = MockHomeView()
        let mockUseCase = MockFetchCategoriesUseCase()
        let categories = [
            Category(id: 1, name: "Action", movies: [
                Movie(id: 10, title: "Die Hard", overview: "Boom", posterPath: nil, voteAverage: 8.0, releaseDate: "1988-07-15")
            ])
        ]
        mockUseCase.resultToReturn = .success(categories)
        let presenter = HomePresenter(view: mockView, fetchCategoriesUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.showCategoriesCalled)
            XCTAssertEqual(mockView.receivedCategories.count, 1)
            XCTAssertEqual(mockView.receivedCategories[0].name, "Action")
            XCTAssertEqual(mockView.receivedCategories[0].movies.count, 1)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadStoresCategoriesOnSuccess() throws {
        let expectation = expectation(description: "store categories")
        let mockView = MockHomeView()
        let mockUseCase = MockFetchCategoriesUseCase()
        let categories = [
            Category(id: 1, name: "Action", movies: []),
            Category(id: 2, name: "Comedy", movies: [])
        ]
        mockUseCase.resultToReturn = .success(categories)
        let presenter = HomePresenter(view: mockView, fetchCategoriesUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(presenter.categories.count, 2)
            XCTAssertEqual(presenter.categories[0].id, 1)
            XCTAssertEqual(presenter.categories[1].id, 2)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadShowsErrorOnFailure() throws {
        let expectation = expectation(description: "show error")
        let mockView = MockHomeView()
        let mockUseCase = MockFetchCategoriesUseCase()
        let error = NSError(domain: "test", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        mockUseCase.resultToReturn = .failure(error)
        let presenter = HomePresenter(view: mockView, fetchCategoriesUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.showErrorCalled)
            XCTAssertEqual(mockView.receivedErrorMessage, "Server error")
            XCTAssertFalse(mockView.showCategoriesCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadHidesLoadingAfterFailure() throws {
        let expectation = expectation(description: "hide loading after failure")
        let mockView = MockHomeView()
        let mockUseCase = MockFetchCategoriesUseCase()
        mockUseCase.resultToReturn = .failure(NSError(domain: "test", code: 500))
        let presenter = HomePresenter(view: mockView, fetchCategoriesUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.hideLoadingCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testCategoriesIsEmptyBeforeViewDidLoad() throws {
        let mockView = MockHomeView()
        let mockUseCase = MockFetchCategoriesUseCase()
        let presenter = HomePresenter(view: mockView, fetchCategoriesUseCase: mockUseCase)

        XCTAssertTrue(presenter.categories.isEmpty)
    }

    func testViewDidLoadShowsEmptyCategoriesWhenNoneExist() throws {
        let expectation = expectation(description: "empty categories")
        let mockView = MockHomeView()
        let mockUseCase = MockFetchCategoriesUseCase()
        mockUseCase.resultToReturn = .success([])
        let presenter = HomePresenter(view: mockView, fetchCategoriesUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.showCategoriesCalled)
            XCTAssertTrue(mockView.receivedCategories.isEmpty)
            XCTAssertTrue(presenter.categories.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }
}
