//
//  MovieRepositoryProtocol.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

protocol MovieRepositoryProtocol {
    func fetchCategories(completion: @escaping FetchCategoriesCompletion)
    func fetchMovies(forCategoryId categoryId: Int, completion: @escaping FetchMoviesCompletion)
    func fetchMovieDetail(movieId: Int, completion: @escaping FetchMovieDetailCompletion)
}
