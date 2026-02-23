//
//  MockMovieRemoteDataSource.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
@testable import IMDUMB

final class MockMovieRemoteDataSource: MovieRemoteDataSourceProtocol {
    var genresToReturn: Result<[CategoryDTO], Error> = .success([])
    var moviesToReturn: [Int: Result<[MovieDTO], Error>] = [:]
    var movieDetailToReturn: Result<MovieDetailDTO, Error> = .failure(NSError(domain: "", code: 0))
    var movieImagesToReturn: Result<[MovieImageDTO], Error> = .success([])
    var movieCreditsToReturn: Result<[ActorDTO], Error> = .success([])

    func fetchGenres(completion: @escaping RemoteFetchGenresCompletion) {
        completion(genresToReturn)
    }

    func fetchMovies(genreId: Int, completion: @escaping RemoteFetchMoviesCompletion) {
        if let result = moviesToReturn[genreId] {
            completion(result)
        } else {
            completion(.success([]))
        }
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping RemoteFetchMovieDetailCompletion) {
        completion(movieDetailToReturn)
    }

    func fetchMovieImages(movieId: Int, completion: @escaping RemoteFetchMovieImagesCompletion) {
        completion(movieImagesToReturn)
    }

    func fetchMovieCast(movieId: Int, completion: @escaping RemoteFetchMovieCastCompletion) {
        completion(movieCreditsToReturn)
    }
}
