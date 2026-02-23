//
//  HomePresenter.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showCategories(_ categories: [Category])
    func showError(_ message: String)
}

protocol HomePresenterProtocol {
    var categories: [Category] { get }
    func viewDidLoad()
    func didSelectMovie(_ movie: Movie)
}

final class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    private let fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol
    private(set) var categories: [Category] = []
    
    init(view: HomeViewProtocol, fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol) {
        self.view = view
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }
    
    func viewDidLoad() {
        view?.showLoading()
        
        fetchCategoriesUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    self?.view?.showCategories(categories)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func didSelectMovie(_ movie: Movie) {
        print(movie)
    }
}
