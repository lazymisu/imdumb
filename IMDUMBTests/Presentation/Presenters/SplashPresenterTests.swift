//
//  SplashPresenterTests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest
@testable import IMDUMB

final class SplashPresenterTests: XCTestCase {

    func testViewDidLoadShowsLoading() throws {
        let mockView = MockSplashView()
        let mockUseCase = MockFetchRemoteConfigUseCase()
        mockUseCase.resultToReturn = .success([:])
        let presenter = SplashPresenter(view: mockView, fetchRemoteConfigUseCase: mockUseCase)

        presenter.viewDidLoad()

        XCTAssertTrue(mockView.showLoadingCalled)
    }

    func testViewDidLoadHidesLoadingAfterSuccess() throws {
        let expectation = expectation(description: "hide loading after success")
        let mockView = MockSplashView()
        let mockUseCase = MockFetchRemoteConfigUseCase()
        mockUseCase.resultToReturn = .success(["welcome_message": "Hello"])
        let presenter = SplashPresenter(view: mockView, fetchRemoteConfigUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.hideLoadingCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadShowsWelcomeMessageFromConfig() throws {
        let expectation = expectation(description: "show welcome message")
        let mockView = MockSplashView()
        let mockUseCase = MockFetchRemoteConfigUseCase()
        mockUseCase.resultToReturn = .success(["welcome_message": "Bienvenido a IMDUMB"])
        let presenter = SplashPresenter(view: mockView, fetchRemoteConfigUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.showWelcomeMessageCalled)
            XCTAssertEqual(mockView.receivedWelcomeMessage, "Bienvenido a IMDUMB")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadShowsEmptyWelcomeMessageWhenKeyIsMissing() throws {
        let expectation = expectation(description: "empty welcome message")
        let mockView = MockSplashView()
        let mockUseCase = MockFetchRemoteConfigUseCase()
        mockUseCase.resultToReturn = .success(["other_key": "value"])
        let presenter = SplashPresenter(view: mockView, fetchRemoteConfigUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.showWelcomeMessageCalled)
            XCTAssertEqual(mockView.receivedWelcomeMessage, "")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadShowsEmptyWelcomeMessageWhenConfigIsEmpty() throws {
        let expectation = expectation(description: "empty config welcome")
        let mockView = MockSplashView()
        let mockUseCase = MockFetchRemoteConfigUseCase()
        mockUseCase.resultToReturn = .success([:])
        let presenter = SplashPresenter(view: mockView, fetchRemoteConfigUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.showWelcomeMessageCalled)
            XCTAssertEqual(mockView.receivedWelcomeMessage, "")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadNavigatesToHomeAfterDelay() throws {
        let expectation = expectation(description: "navigate to home")
        let mockView = MockSplashView()
        let mockUseCase = MockFetchRemoteConfigUseCase()
        mockUseCase.resultToReturn = .success(["welcome_message": "Hello"])
        let presenter = SplashPresenter(view: mockView, fetchRemoteConfigUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertTrue(mockView.navigateToHomeCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testViewDidLoadShowsErrorOnFailure() throws {
        let expectation = expectation(description: "show error on failure")
        let mockView = MockSplashView()
        let mockUseCase = MockFetchRemoteConfigUseCase()
        let error = NSError(domain: "test", code: 503, userInfo: [NSLocalizedDescriptionKey: "Service unavailable"])
        mockUseCase.resultToReturn = .failure(error)
        let presenter = SplashPresenter(view: mockView, fetchRemoteConfigUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.showErrorCalled)
            XCTAssertEqual(mockView.receivedErrorMessage, "Service unavailable")
            XCTAssertFalse(mockView.showWelcomeMessageCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadHidesLoadingAfterFailure() throws {
        let expectation = expectation(description: "hide loading after failure")
        let mockView = MockSplashView()
        let mockUseCase = MockFetchRemoteConfigUseCase()
        mockUseCase.resultToReturn = .failure(NSError(domain: "test", code: 500))
        let presenter = SplashPresenter(view: mockView, fetchRemoteConfigUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.hideLoadingCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testViewDidLoadDoesNotNavigateToHomeOnFailure() throws {
        let expectation = expectation(description: "no navigation on failure")
        let mockView = MockSplashView()
        let mockUseCase = MockFetchRemoteConfigUseCase()
        mockUseCase.resultToReturn = .failure(NSError(domain: "test", code: 500))
        let presenter = SplashPresenter(view: mockView, fetchRemoteConfigUseCase: mockUseCase)

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(mockView.navigateToHomeCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
}
