//
//  CategoryCollectionViewCell.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

protocol CategoryCollectionViewCellDelegate: AnyObject {
    func categoryCell(_ cell: CategoryCollectionViewCell, didSelectMovie movie: Movie)
}

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var lblCategory: UILabel!
    @IBOutlet private weak var tbvMovies: UITableView!
    
    // MARK: - Properties
    
    weak var delegate: CategoryCollectionViewCellDelegate?
    private var movies: [Movie] = []
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTableView()
    }

    private func setupTableView() {
        tbvMovies.register(
            UINib(nibName: "MovieTableViewCell", bundle: nil),
            forCellReuseIdentifier: "MovieTableViewCell"
        )
    }
        
    func configure(with category: Category) {
        lblCategory.text = category.name
        movies = category.movies
        tbvMovies.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension CategoryCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieTableViewCell",
            for: indexPath
        ) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryCollectionViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        delegate?.categoryCell(self, didSelectMovie: movie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
