//
//  MockMovieRepository.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
@testable import IMDUMB

final class MockMovieRepository: MovieRepositoryProtocol {
    var categoriesToReturn: Result<[IMDUMB.Category], Error> = .success([])
    var moviesToReturn: [Int: Result<[Movie], Error>] = [:]
    var movieDetailToReturn: Result<MovieDetail, Error> = .failure(NSError(domain: "", code: 0))
    
    func fetchCategories(completion: @escaping FetchCategoriesCompletion) {
        completion(categoriesToReturn)
    }
    
    func fetchMovies(forCategoryId categoryId: Int, completion: @escaping FetchMoviesCompletion) {
        if let result = moviesToReturn[categoryId] {
            completion(result)
        } else {
            completion(.success([]))
        }
    }
    
    func fetchMovieDetail(movieId: Int, completion: @escaping FetchMovieDetailCompletion) {
        completion(movieDetailToReturn)
    }
}
