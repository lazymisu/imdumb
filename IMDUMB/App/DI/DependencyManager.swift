//
//  DependencyManager.swift
//  IMDUMB
//
//  Created by felix on 22/02/26.
//

// MARK: - SOLID: Dependency Inversion Principle (DIP)
// DependencyManager es el composition root de la aplicación. Aquí se conectan
// las abstracciones (protocolos) con sus implementaciones concretas.
//
// Los módulos de alto nivel (Presenters) NO dependen de módulos de bajo nivel
// (APIClient, FirebaseRemoteConfigDataSource). Ambos dependen de abstracciones:
//   - HomePresenter depende de FetchCategoriesUseCaseProtocol (no de FetchCategoriesUseCase)
//   - FetchCategoriesUseCase depende de MovieRepositoryProtocol (no de MovieRepository)
//   - MovieRepository depende de MovieRemoteDataSourceProtocol (no de MovieRemoteDataSource)
//
// Esto permite:
//   1. Inyectar mocks en tests sin modificar los presenters ni use cases.
//   2. Cambiar implementaciones (ej. migrar de Alamofire a URLSession) sin afectar capas superiores.

final class DependencyManager {
    static let shared = DependencyManager()
    
    private init() {}
    
    // MARK: - Data Sources
    
    lazy var firebaseRemoteConfigDataSource: FirebaseRemoteConfigDataSourceProtocol = {
        FirebaseRemoteConfigDataSource()
    }()
    
    lazy var apiClient: APIClientProtocol = {
        APIClient()
    }()
    
    lazy var movieRemoteDataSource: MovieRemoteDataSourceProtocol = {
        MovieRemoteDataSource(apiClient: apiClient)
    }()
    
    // MARK: - Repositories
    
    lazy var remoteConfigRepository: RemoteConfigRepositoryProtocol = {
        RemoteConfigRepository(remoteDataSource: firebaseRemoteConfigDataSource)
    }()
    
    lazy var movieRepository: MovieRepositoryProtocol = {
        MovieRepository(remoteDataSource: movieRemoteDataSource)
    }()
    
    // MARK: - Use Cases
    
    func makeFetchRemoteConfigUseCase() -> FetchRemoteConfigUseCaseProtocol {
        FetchRemoteConfigUseCase(repository: remoteConfigRepository)
    }
    
    func makeFetchCategoriesUseCase() -> FetchCategoriesUseCaseProtocol {
        FetchCategoriesUseCase(repository: movieRepository)
    }
    
    func makeFetchMovieDetailUseCase() -> FetchMovieDetailUseCaseProtocol {
        FetchMovieDetailUseCase(repository: movieRepository)
    }
    
    // MARK: - Presenters
    
    func makeSplashPresenter(view: SplashViewProtocol) -> SplashPresenterProtocol {
        SplashPresenter(
            view: view,
            fetchRemoteConfigUseCase: makeFetchRemoteConfigUseCase()
        )
    }
    
    func makeHomePresenter(view: HomeViewProtocol) -> HomePresenter {
        HomePresenter(
            view: view,
            fetchCategoriesUseCase: makeFetchCategoriesUseCase()
        )
    }
    
    func makeMovieDetailPresenter(view: MovieDetailViewProtocol, movieId: Int) -> MovieDetailPresenterProtocol {
        MovieDetailPresenter(
            view: view,
            movieId: movieId,
            fetchMovieDetailUseCase: makeFetchMovieDetailUseCase()
        )
    }
}
