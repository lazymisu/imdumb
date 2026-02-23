//
//  MovieDetailViewController.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var clvImages: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblRating: UILabel!
    @IBOutlet private weak var lblReleaseDate: UILabel!
    @IBOutlet private weak var lblOverview: UILabel!
    @IBOutlet private weak var clvActors: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var bottomBarView: UIView!
    
    // MARK: - Properties
    
    var movieId: Int = 0
    var movieTitle: String = ""
    private var presenter: MovieDetailPresenterProtocol!
    private var images: [MovieImage] = []
    private var cast: [Actor] = []
    private let bottomSheetDelegate = BottomSheetTransitioningDelegate()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = movieTitle
        setupCarousel()
        setupActorsCollection()
        presenter = DependencyManager.shared.makeMovieDetailPresenter(view: self, movieId: movieId)
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupCarousel() {
        clvImages.register(
            UINib(nibName: "ImageCarouselCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ImageCarouselCollectionViewCell"
        )
    }
    
    private func setupActorsCollection() {
        clvActors.register(
            UINib(nibName: "ActorCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ActorCollectionViewCell"
        )
    }
    
    // MARK: - Actions
    
    @IBAction private func didTapRecommend(_ sender: UIButton) {
        guard let detail = presenter.movieDetail else { return }
        let recommendVC = RecommendViewController(nibName: "RecommendViewController", bundle: nil)
        recommendVC.movieDetail = detail
        recommendVC.modalPresentationStyle = .custom
        recommendVC.transitioningDelegate = bottomSheetDelegate
        present(recommendVC, animated: true)
    }
}

// MARK: - MovieDetailViewProtocol

extension MovieDetailViewController: MovieDetailViewProtocol {
    
    func showLoading() {
        activityIndicator.startAnimating()
        scrollView.isHidden = true
        bottomBarView.isHidden = true
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        scrollView.isHidden = false
        bottomBarView.isHidden = false
    }
    
    func displayMovieDetail(_ detail: MovieDetail) {
        lblTitle.text = detail.title
        lblRating.text = "⭐ \(detail.formattedRating) / 10"
        lblReleaseDate.text = "Fecha de estreno: \(detail.releaseDate)"
        
        if let htmlAttributed = detail.overviewHTML {
            lblOverview.attributedText = htmlAttributed
        } else {
            lblOverview.text = detail.overview
        }
        
        images = Array(detail.images.prefix(10))
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.isHidden = images.isEmpty
        clvImages.reloadData()
        
        cast = Array(detail.cast.prefix(20))
        clvActors.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Reintentar", style: .default) { [weak self] _ in
                self?.presenter.viewDidLoad()
            }
        )
        alert.addAction(
            UIAlertAction(title: "Volver", style: .cancel) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clvImages {
            return images.count
        } else {
            return cast.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clvImages {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ImageCarouselCollectionViewCell",
                for: indexPath
            ) as? ImageCarouselCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: images[indexPath.item].imageURL)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ActorCollectionViewCell",
                for: indexPath
            ) as? ActorCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: cast[indexPath.item])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == clvImages {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        } else {
            return CGSize(width: 90, height: 140)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension MovieDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == clvImages {
            let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            pageControl.currentPage = page
        }
    }
}
