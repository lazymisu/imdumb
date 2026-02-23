//
//  RemoteConfigRepository.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

final class RemoteConfigRepository: RemoteConfigRepositoryProtocol {
    private let remoteDataSource: FirebaseRemoteConfigDataSourceProtocol
    
    init(remoteDataSource: FirebaseRemoteConfigDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchRemoteConfig(completion: @escaping FetchRemoteConfigCompletion) {
        remoteDataSource.fetchConfig(completion: completion)
    }
}
