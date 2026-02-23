//
//  ImageCarouselCollectionViewCell.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

final class ImageCarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(with url: URL?) {
        loadImage(from: url)
    }
    
    private func loadImage(from url: URL?) {
        guard let url = url else {
            imageView.image = UIImage(systemName: "photo")
            imageView.contentMode = .scaleAspectFit
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.imageView.image = image
                self?.imageView.contentMode = .scaleAspectFill
            }
        }.resume()
    }
}
