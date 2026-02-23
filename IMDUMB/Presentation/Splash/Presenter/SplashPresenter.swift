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
    func showWelcomeMessage(_ message: String)
}

protocol SplashPresenterProtocol {
    func viewDidLoad()
}

final class SplashPresenter: SplashPresenterProtocol {
    weak var view: SplashViewProtocol?
    private let fetchRemoteConfigUseCase: FetchRemoteConfigUseCaseProtocol
    
    init(
        view: SplashViewProtocol,
        fetchRemoteConfigUseCase: FetchRemoteConfigUseCaseProtocol
    ) {
        self.view = view
        self.fetchRemoteConfigUseCase = fetchRemoteConfigUseCase
    }
    
    func viewDidLoad() {
        view?.showLoading()
        
        fetchRemoteConfigUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()

                switch result {
                case .success(let config):
                    let welcomeMessage = config["welcome_message"] ?? ""
                    self?.view?.showWelcomeMessage(welcomeMessage)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.view?.navigateToHome()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
}
