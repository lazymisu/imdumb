//
//  MockMovieDetailView.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
@testable import IMDUMB

final class MockMovieDetailView: MovieDetailViewProtocol {
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var displayMovieDetailCalled = false
    var showErrorCalled = false
    var receivedMovieDetail: MovieDetail?
    var receivedErrorMessage: String?

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }

    func displayMovieDetail(_ detail: MovieDetail) {
        displayMovieDetailCalled = true
        receivedMovieDetail = detail
    }

    func showError(_ message: String) {
        showErrorCalled = true
        receivedErrorMessage = message
    }
}
