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

protocol MovieRemoteDataSourceProtocol {
    func fetchGenres(completion: @escaping RemoteFetchGenresCompletion)
    func fetchMovies(genreId: Int, completion: @escaping RemoteFetchMoviesCompletion)
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
}
