//
//  DependencyManager.swift
//  IMDUMB
//
//  Created by felix on 22/02/26.
//

final class DependencyManager {
    static let shared = DependencyManager()
    
    private init() {}
    
    func makeFirebaseRemoteConfigDataSource() -> FirebaseRemoteConfigDataSourceProtocol {
        FirebaseRemoteConfigDataSource()
    }
    
    func makeRemoteConfigRepository() -> RemoteConfigRepositoryProtocol {
        RemoteConfigRepository(remoteDataSource: makeFirebaseRemoteConfigDataSource())
    }
    
    func makeFetchRemoteConfigUseCase() -> FetchRemoteConfigUseCaseProtocol {
        FetchRemoteConfigUseCase(repository: makeRemoteConfigRepository())
    }
    
    func makeSplashPresenter(view: SplashViewProtocol) -> SplashPresenterProtocol {
        SplashPresenter(
            view: view,
            fetchRemoteConfigUseCase: makeFetchRemoteConfigUseCase()
        )
    }
}
