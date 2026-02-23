//
//  MockRemoteConfigRepository.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

@testable import IMDUMB

final class MockRemoteConfigRepository: RemoteConfigRepositoryProtocol {
    var configToReturn: Result<[String: String], Error> = .success([:])
    
    func fetchRemoteConfig(completion: @escaping FetchRemoteConfigCompletion) {
        completion(configToReturn)
    }
}
