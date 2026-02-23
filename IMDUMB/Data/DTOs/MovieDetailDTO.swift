//
//  MovieDetailDTO.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

struct MovieDetailDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let voteAverage: Double
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

struct MovieImagesResponse: Decodable {
    let backdrops: [MovieImageDTO]
    let posters: [MovieImageDTO]
}

struct MovieImageDTO: Decodable {
    let filePath: String
    let width: Int
    let height: Int
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case width, height
    }
    
    func toDomain() -> MovieImage {
        return MovieImage(
            filePath: filePath,
            width: width,
            height: height
        )
    }
}

struct MovieCastResponse: Decodable {
    let cast: [ActorDTO]
}

struct ActorDTO: Decodable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
    
    func toDomain() -> Actor {
        return Actor(
            id: id,
            name: name,
            character: character,
            profilePath: profilePath
        )
    }
}
