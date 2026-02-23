//
//  DependencyManager.swift
//  IMDUMB
//
//  Created by felix on 22/02/26.
//

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
}
