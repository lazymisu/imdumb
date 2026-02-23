//
//  SplashViewController.swift
//  IMDUMB
//
//  Created by felix on 22/02/26.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var lblWelcome: UILabel!
    
    // MARK: - Properties
    
    private var presenter: SplashPresenterProtocol!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DependencyManager.shared.makeSplashPresenter(view: self)
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
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(alert, animated: true)
    }
    
    func showWelcomeMessage(_ message: String) {
        lblWelcome.text = message
        lblWelcome.isHidden = false
    }
}
