//
//  MockHomeView.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
@testable import IMDUMB

final class MockHomeView: HomeViewProtocol {
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showCategoriesCalled = false
    var showErrorCalled = false
    var receivedCategories: [IMDUMB.Category] = []
    var receivedErrorMessage: String?

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }

    func showCategories(_ categories: [IMDUMB.Category]) {
        showCategoriesCalled = true
        receivedCategories = categories
    }

    func showError(_ message: String) {
        showErrorCalled = true
        receivedErrorMessage = message
    }
}
