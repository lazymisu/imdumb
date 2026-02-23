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
    
    func fetchMovieDetail(movieId: Int, completion: @escaping FetchMovieDetailCompletion) {
        let group = DispatchGroup()
        var detailDTO: MovieDetailDTO?
        var imageDTOs: [MovieImageDTO] = []
        var actorDTOs: [ActorDTO] = []
        var fetchError: Error?
        let lock = NSLock()
        
        group.enter()
        remoteDataSource.fetchMovieDetail(movieId: movieId) { result in
            lock.lock()
            switch result {
            case .success(let dto):
                detailDTO = dto
            case .failure(let error):
                fetchError = error
            }
            lock.unlock()
            group.leave()
        }
        
        group.enter()
        remoteDataSource.fetchMovieImages(movieId: movieId) { result in
            lock.lock()
            switch result {
            case .success(let dtos):
                imageDTOs = dtos
            case .failure(let error):
                if fetchError == nil { fetchError = error }
            }
            lock.unlock()
            group.leave()
        }
        
        group.enter()
        remoteDataSource.fetchMovieCast(movieId: movieId) { result in
            lock.lock()
            switch result {
            case .success(let dtos):
                actorDTOs = dtos
            case .failure(let error):
                if fetchError == nil { fetchError = error }
            }
            lock.unlock()
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = fetchError, detailDTO == nil {
                completion(.failure(error))
                return
            }
            
            guard let detail = detailDTO else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            let movieDetail = MovieDetail(
                id: detail.id,
                title: detail.title,
                overview: detail.overview,
                voteAverage: detail.voteAverage,
                releaseDate: detail.releaseDate ?? "",
                images: imageDTOs.map { $0.toDomain() },
                cast: actorDTOs.map { $0.toDomain() }
            )
            
            completion(.success(movieDetail))
        }
    }
}
