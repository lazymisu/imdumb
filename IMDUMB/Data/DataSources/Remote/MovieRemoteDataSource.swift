//
//  MovieRemoteDataSource.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
import Alamofire

typealias RemoteFetchGenresCompletion = (Result<[CategoryDTO], Error>) -> Void
typealias RemoteFetchMoviesCompletion = (Result<[MovieDTO], Error>) -> Void
typealias RemoteFetchMovieDetailCompletion = (Result<MovieDetailDTO, Error>) -> Void
typealias RemoteFetchMovieImagesCompletion = (Result<[MovieImageDTO], Error>) -> Void
typealias RemoteFetchMovieCastCompletion = (Result<[ActorDTO], Error>) -> Void

protocol MovieRemoteDataSourceProtocol {
    func fetchGenres(completion: @escaping RemoteFetchGenresCompletion)
    func fetchMovies(genreId: Int, completion: @escaping RemoteFetchMoviesCompletion)
    func fetchMovieDetail(movieId: Int, completion: @escaping RemoteFetchMovieDetailCompletion)
    func fetchMovieImages(movieId: Int, completion: @escaping RemoteFetchMovieImagesCompletion)
    func fetchMovieCast(movieId: Int, completion: @escaping RemoteFetchMovieCastCompletion)
}

final class MovieRemoteDataSource: MovieRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchGenres(completion: @escaping RemoteFetchGenresCompletion) {
        apiClient.request(
            endpoint: "/genre/movie/list",
            method: .get,
            parameters: nil
        ) { (result: Result<GenreListResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.genres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovies(genreId: Int, completion: @escaping RemoteFetchMoviesCompletion) {
        let parameters: Parameters = ["with_genres": genreId]
        
        apiClient.request(
            endpoint: "/discover/movie",
            method: .get,
            parameters: parameters
        ) { (result: Result<MovieListResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetail(movieId: Int, completion: @escaping RemoteFetchMovieDetailCompletion) {
        apiClient.request(
            endpoint: "/movie/\(movieId)",
            method: .get,
            parameters: nil
        ) { (result: Result<MovieDetailDTO, Error>) in
            switch result {
            case .success(let dto):
                completion(.success(dto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieImages(movieId: Int, completion: @escaping RemoteFetchMovieImagesCompletion) {
        let parameters: Parameters = ["include_image_language": "es,null"]
        
        apiClient.request(
            endpoint: "/movie/\(movieId)/images",
            method: .get,
            parameters: parameters
        ) { (result: Result<MovieImagesResponse, Error>) in
            switch result {
            case .success(let response):
                let images = response.backdrops + response.posters
                completion(.success(images))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieCast(movieId: Int, completion: @escaping RemoteFetchMovieCastCompletion) {
        apiClient.request(
            endpoint: "/movie/\(movieId)/credits",
            method: .get,
            parameters: nil
        ) { (result: Result<MovieCastResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.cast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
