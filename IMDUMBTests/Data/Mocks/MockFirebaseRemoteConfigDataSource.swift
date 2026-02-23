//
//  MockFirebaseRemoteConfigDataSource.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
@testable import IMDUMB

final class MockFirebaseRemoteConfigDataSource: FirebaseRemoteConfigDataSourceProtocol {
    var configToReturn: Result<[String: String], Error> = .success([:])

    func fetchConfig(completion: @escaping FetchRemoteConfigCompletion) {
        completion(configToReturn)
    }
}
