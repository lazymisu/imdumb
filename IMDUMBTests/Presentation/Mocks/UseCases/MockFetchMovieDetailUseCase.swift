//
//  MockFetchMovieDetailUseCase.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
@testable import IMDUMB

final class MockFetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol {
    var resultToReturn: Result<MovieDetail, Error> = .failure(NSError(domain: "", code: 0))
    var receivedMovieId: Int?

    func execute(movieId: Int, completion: @escaping FetchMovieDetailCompletion) {
        receivedMovieId = movieId
        completion(resultToReturn)
    }
}
