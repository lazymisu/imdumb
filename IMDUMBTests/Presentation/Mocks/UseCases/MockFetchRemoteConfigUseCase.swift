//
//  MockFetchRemoteConfigUseCase.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
@testable import IMDUMB

final class MockFetchRemoteConfigUseCase: FetchRemoteConfigUseCaseProtocol {
    var resultToReturn: Result<[String: String], Error> = .success([:])

    func execute(completion: @escaping FetchRemoteConfigCompletion) {
        completion(resultToReturn)
    }
}
