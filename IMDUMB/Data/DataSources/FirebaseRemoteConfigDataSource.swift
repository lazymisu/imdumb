//
//  FirebaseRemoteConfigDataSource.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
import FirebaseRemoteConfig

protocol FirebaseRemoteConfigDataSourceProtocol {
    func fetchConfig(completion: @escaping FetchRemoteConfigCompletion)
}

final class FirebaseRemoteConfigDataSource: FirebaseRemoteConfigDataSourceProtocol {
    private let remoteConfig: RemoteConfig
    
    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        
        remoteConfig.setDefaults([
            "welcome_message": NSString(string: "Bienvenido a IMDUMB!"),
            "feature_detail_enabled": NSNumber(value: true)
        ])
    }
    
    func fetchConfig(completion: @escaping FetchRemoteConfigCompletion) {
        remoteConfig.fetch { [weak self] status, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard status == .success else {
                completion(.failure(NSError(
                    domain: "RemoteConfig",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Fetch failed with status: \(status.rawValue)"]
                )))
                return
            }
            
            self.remoteConfig.activate { _, _ in
                let keys = self.remoteConfig.allKeys(from: .remote)
                
                var configDict: [String: String] = [:]
                for key in keys {
                    configDict[key] = self.remoteConfig.configValue(forKey: key).stringValue
                }
                
                completion(.success(configDict))
            }
        }
    }
}
