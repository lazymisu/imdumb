//
//  MovieRepository.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    private let remoteDataSource: MovieRemoteDataSourceProtocol
    
    init(remoteDataSource: MovieRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchCategories(completion: @escaping FetchCategoriesCompletion) {
        remoteDataSource.fetchGenres { result in
            switch result {
            case .success(let dtos):
                let categories = dtos.map { $0.toDomain() }
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovies(forCategoryId categoryId: Int, completion: @escaping FetchMoviesCompletion) {
        remoteDataSource.fetchMovies(genreId: categoryId) { result in
            switch result {
            case .success(let dtos):
                let movies = dtos.map { $0.toDomain() }
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
