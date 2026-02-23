//
//  Environment.swift
//  IMDUMB
//
//  Created by felix on 22/02/26.
//

import Foundation

enum Environment {
    
    // MARK: - Private
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found")
        }
        return dict
    }()
    
    // MARK: - Public
    
    static let apiBaseURL: String = {
        guard let value = infoDictionary["API_BASE_URL"] as? String else {
            fatalError("API_BASE_URL not set in plist")
        }
        return value
    }()
    
    static let apiKey: String = {
        guard let value = infoDictionary["API_KEY"] as? String else {
            fatalError("API_KEY not set in plist")
        }
        return value
    }()
}
