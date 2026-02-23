//
//  Category.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

struct Category: Equatable {
    let id: Int
    let name: String
    var movies: [Movie]
}
