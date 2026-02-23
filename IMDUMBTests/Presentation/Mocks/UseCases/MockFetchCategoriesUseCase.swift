//
//  MockFetchCategoriesUseCase.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation
@testable import IMDUMB

final class MockFetchCategoriesUseCase: FetchCategoriesUseCaseProtocol {
    var resultToReturn: Result<[IMDUMB.Category], Error> = .success([])

    func execute(completion: @escaping FetchCategoriesCompletion) {
        completion(resultToReturn)
    }
}
