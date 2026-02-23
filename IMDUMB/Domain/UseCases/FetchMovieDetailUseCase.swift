//
//  FetchMovieDetailUseCase.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

typealias FetchMovieDetailCompletion = (Result<MovieDetail, Error>) -> Void
typealias FetchMovieImagesCompletion = (Result<[MovieImage], Error>) -> Void
typealias FetchMovieCastCompletion = (Result<[Actor], Error>) -> Void

protocol FetchMovieDetailUseCaseProtocol {
    func execute(movieId: Int, completion: @escaping FetchMovieDetailCompletion)
}

final class FetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(movieId: Int, completion: @escaping FetchMovieDetailCompletion) {
        repository.fetchMovieDetail(movieId: movieId, completion: completion)
    }
}
