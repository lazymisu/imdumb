//
//  FetchRemoteConfigUseCase.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

typealias FetchRemoteConfigCompletion = (Result<[String: String], Error>) -> Void

protocol FetchRemoteConfigUseCaseProtocol {
    func execute(completion: @escaping FetchRemoteConfigCompletion)
}

final class FetchRemoteConfigUseCase: FetchRemoteConfigUseCaseProtocol {
    private let repository: RemoteConfigRepositoryProtocol
    
    init(repository: RemoteConfigRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping FetchRemoteConfigCompletion) {
        repository.fetchRemoteConfig(completion: completion)
    }
}
