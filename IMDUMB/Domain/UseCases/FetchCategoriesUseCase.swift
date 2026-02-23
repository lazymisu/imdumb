//
//  FetchCategoriesUseCase.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

typealias FetchCategoriesCompletion = (Result<[Category], Error>) -> Void
typealias FetchMoviesCompletion = (Result<[Movie], Error>) -> Void

protocol FetchCategoriesUseCaseProtocol {
    func execute(completion: @escaping FetchCategoriesCompletion)
}

final class FetchCategoriesUseCase: FetchCategoriesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping FetchCategoriesCompletion) {
        repository.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.fetchMoviesForCategories(categories, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchMoviesForCategories(
        _ categories: [Category],
        completion: @escaping FetchCategoriesCompletion
    ) {
        let group = DispatchGroup()
        var populatedCategories: [Category] = []
        var fetchError: Error?
        let lock = NSLock()
        
        for category in categories {
            group.enter()
            repository.fetchMovies(forCategoryId: category.id) { result in
                lock.lock()
                switch result {
                case .success(let movies):
                    var cat = category
                    cat.movies = movies
                    populatedCategories.append(cat)
                case .failure(let error):
                    fetchError = error
                }
                lock.unlock()
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                let sorted = populatedCategories.sorted { $0.id < $1.id }
                completion(.success(sorted))
            }
        }
    }
}
