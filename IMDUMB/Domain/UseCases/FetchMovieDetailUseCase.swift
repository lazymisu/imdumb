//
//  FetchMovieDetailUseCase.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

// MARK: - SOLID: Open/Closed Principle (OCP)
// FetchMovieDetailUseCase está cerrado para modificación pero abierto para extensión.
// Depende del protocolo MovieRepositoryProtocol: si mañana se necesita obtener
// el detalle desde caché local o desde otro servicio, basta con crear una nueva
// implementación del repositorio sin modificar este use case.
// Además, el protocolo FetchMovieDetailUseCaseProtocol permite sustituir
// esta implementación completa (por ejemplo, con un mock en tests) sin tocar
// los presenters que lo consumen.

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
