//
//  CategoryDTO.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

struct GenreListResponse: Decodable {
    let genres: [CategoryDTO]
}

struct CategoryDTO: Decodable {
    let id: Int
    let name: String
    
    func toDomain() -> Category {
        return Category(id: id, name: name, movies: [])
    }
}
