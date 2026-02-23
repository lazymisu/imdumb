//
//  MovieDetail.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

struct MovieDetail: Equatable {
    let id: Int
    let title: String
    let overview: String
    let voteAverage: Double
    let releaseDate: String
    let images: [MovieImage]
    let cast: [Actor]
    
    var formattedRating: String {
        return String(format: "%.1f", voteAverage)
    }
    
    var overviewHTML: NSAttributedString? {
        let htmlString = """
        <html>
        <head>
        <style>
        body {
            font-family: -apple-system, Helvetica, Arial, sans-serif;
            font-size: 15px;
            color: #F54927;
        }
        </style>
        </head>
        <body>\(overview)</body>
        </html>
        """
        guard let data = htmlString.data(using: .utf8) else { return nil }
        return try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
}

struct MovieImage: Equatable {
    let filePath: String
    let width: Int
    let height: Int
    
    var imageURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w780\(filePath)")
    }
}

struct Actor: Equatable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(profilePath)")
    }
}
