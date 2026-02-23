//
//  SplashViewController.swift
//  IMDUMB
//
//  Created by felix on 22/02/26.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var presenter: SplashPresenterProtocol!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SplashPresenter(view: self)
        presenter.viewDidLoad()
    }
}

// MARK: - SplashViewProtocol

extension SplashViewController: SplashViewProtocol {
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func navigateToHome() {
        // TODO: Push to home screen
    }
    
    func showError(message: String) {
        // TODO: Show alert with message
    }
}
