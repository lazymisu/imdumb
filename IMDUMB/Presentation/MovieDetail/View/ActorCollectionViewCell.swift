//
//  ActorCollectionViewCell.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

final class ActorCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imgProfile: UIImageView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblCharacter: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.layer.cornerRadius = 40
    }
    
    // MARK: - Configure
    
    func configure(with actor: Actor) {
        lblName.text = actor.name
        lblCharacter.text = actor.character
        loadImage(from: actor.profileURL)
    }
    
    private func loadImage(from url: URL?) {
        guard let url = url else {
            imgProfile.image = UIImage(systemName: "person.circle.fill")
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.imgProfile.image = image
            }
        }.resume()
    }
}

