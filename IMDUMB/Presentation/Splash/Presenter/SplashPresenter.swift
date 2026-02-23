//
//  SplashPresenter.swift
//  IMDUMB
//
//  Created by felix on 22/02/26.
//

import Foundation

protocol SplashViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func navigateToHome()
    func showError(message: String)
}

protocol SplashPresenterProtocol {
    func viewDidLoad()
}

final class SplashPresenter: SplashPresenterProtocol {
    weak var view: SplashViewProtocol?
    
    init(view: SplashViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showLoading()
        
        // TODO: Fetch remote config...
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.view?.hideLoading()
            self?.view?.navigateToHome()
        }
    }
}
