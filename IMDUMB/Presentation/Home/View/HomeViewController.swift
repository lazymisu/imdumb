//
//  HomeViewController.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet private weak var clvCategories: UICollectionView!
    
    // MARK: - Properties
    
    private var presenter: HomePresenterProtocol!
    private var categories: [Category] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        title = "IMDUMB"
        presenter = DependencyManager.shared.makeHomePresenter(view: self)
        presenter.viewDidLoad()
        setupCollectionView()
    }

    // MARK: - Methods
    
    private func setupCollectionView() {
        clvCategories.register(
            UINib(nibName: "CategoryCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "CategoryCollectionViewCell"
        )
    }
}

// MARK: - HomeViewProtocol

extension HomeViewController: HomeViewProtocol {
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func showCategories(_ categories: [Category]) {
        self.categories = categories
        clvCategories.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Reintentar", style: .default) { [weak self] _ in
                self?.presenter.viewDidLoad()
            }
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CategoryCollectionViewCell",
            for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: categories[indexPath.item])
//        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.bounds.size
    }
}
