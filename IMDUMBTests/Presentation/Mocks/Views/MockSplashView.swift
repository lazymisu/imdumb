//
//  MockSplashView.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
@testable import IMDUMB

final class MockSplashView: SplashViewProtocol {
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var navigateToHomeCalled = false
    var showErrorCalled = false
    var showWelcomeMessageCalled = false
    var receivedErrorMessage: String?
    var receivedWelcomeMessage: String?

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }

    func navigateToHome() {
        navigateToHomeCalled = true
    }

    func showError(message: String) {
        showErrorCalled = true
        receivedErrorMessage = message
    }

    func showWelcomeMessage(_ message: String) {
        showWelcomeMessageCalled = true
        receivedWelcomeMessage = message
    }
}
