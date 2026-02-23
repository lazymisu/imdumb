//
//  RemoteConfigRepositoryProtocol.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

protocol RemoteConfigRepositoryProtocol {
    func fetchRemoteConfig(completion: @escaping FetchRemoteConfigCompletion)
}
