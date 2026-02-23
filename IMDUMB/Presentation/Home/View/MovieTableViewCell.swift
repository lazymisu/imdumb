//
//  MovieTableViewCell.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet private weak var imgPoster: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblRating: UILabel!
    @IBOutlet private weak var lblReleaseDate: UILabel!

    func configure(with movie: Movie) {
        lblTitle.text = movie.title
        lblRating.text = "⭐ \(String(format: "%.1f", movie.voteAverage))"
        lblReleaseDate.text = movie.releaseDate
        loadImage(from: movie.posterURL)
    }
    
    private func loadImage(from url: URL?) {
        guard let url = url else {
            imgPoster.image = UIImage(systemName: "film")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.imgPoster.image = image
            }
        }.resume()
    }
}
