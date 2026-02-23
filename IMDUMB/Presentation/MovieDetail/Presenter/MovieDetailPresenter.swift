//
//  MovieDetailPresenter.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import Foundation

protocol MovieDetailViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayMovieDetail(_ detail: MovieDetail)
    func showError(_ message: String)
}

protocol MovieDetailPresenterProtocol {
    var movieDetail: MovieDetail? { get }
    func viewDidLoad()
    func didTapRecommend()
}

final class MovieDetailPresenter: MovieDetailPresenterProtocol {
    weak var view: MovieDetailViewProtocol?
    private let movieId: Int
    private let fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol
    
    private(set) var movieDetail: MovieDetail?
    
    init(
        view: MovieDetailViewProtocol,
        movieId: Int,
        fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol
    ) {
        self.view = view
        self.movieId = movieId
        self.fetchMovieDetailUseCase = fetchMovieDetailUseCase
    }
    
    func viewDidLoad() {
        view?.showLoading()
        
        fetchMovieDetailUseCase.execute(movieId: movieId) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                
                switch result {
                case .success(let detail):
                    self?.movieDetail = detail
                    self?.view?.displayMovieDetail(detail)
                    
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func didTapRecommend() {
        // La vista se encarga de presentar el modal
    }
}
