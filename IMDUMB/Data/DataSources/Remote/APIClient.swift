//
//  APIClient.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
import Alamofire

enum APIError: Error, LocalizedError {
    case invalidResponse
    case networkError(String)
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        }
    }
}

protocol APIClientProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class APIClient: APIClientProtocol {
    
    private let session: Session
    private let baseURL: String
    private let apiKey: String
    
    init(
        baseURL: String = Environment.apiBaseURL,
        apiKey: String = Environment.apiKey,
        session: Session = .default
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.session = session
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let url = "\(baseURL)\(endpoint)"
        
        var allParameters: Parameters = ["api_key": apiKey, "language": "es-ES"]
        if let parameters = parameters {
            allParameters.merge(parameters) { _, new in new }
        }
        
        session.request(
            url,
            method: method,
            parameters: allParameters,
            encoding: URLEncoding.default
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                if let data = response.data,
                   let bodyString = String(data: data, encoding: .utf8) {
                    print("API Error Body: \(bodyString)")
                }
                completion(.failure(APIError.networkError(error.localizedDescription)))
            }
        }
    }
}
