//
//  Injection.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 25/05/22.
//

import CoreModule
import GameModule
import AboutModule
import GenreModule
import StoreModule

struct Injection {
    
    // swiftlint:disable force_cast
    // MARK: Game
    public func provideGames<U: UseCase>() -> U where U.Request == GameParamModel, U.Response == GamesModel {
        let remote = GetGamesRemoteDataSource()
        let mapper = GamesTransformer()

        let repository = GetGamesRepository(remoteDataSource: remote, mapper: mapper)
        return Interactor(repository: repository) as! U
    }

    public func provideGameDetail<U: UseCase>(gameDetail: GameDetailModel?) -> U where U.Request == Int, U.Response == GameDetailModel {
        let remote = GetGameDetailRemoteDataSource()
        
        let realm = DBManager.shared.database
        let locale = GetFavoriteGamesLocaleDataSource(realm: realm)

        let mapper = GameDetailTransformer()

        let repository = GetGameDetailRepository(localeDataSource: locale, remoteDataSource: remote, mapper: mapper, gameDetail: gameDetail)
        return Interactor(repository: repository) as! U
    }

    public func provideUpdateFavoriteGame<U: UseCase>() -> U where U.Request == GameDetailModel, U.Response == Bool {
        let realm = DBManager.shared.database
        let locale = GetFavoriteGamesLocaleDataSource(realm: realm)

        let mapper = GameDetailTransformer()

        let repository = UpdateFavoriteGameRepository(localeDataSource: locale, mapper: mapper)
        return Interactor(repository: repository) as! U
    }

    public func provideFavoriteGames<U: UseCase>() -> U where U.Request == Any, U.Response == [GameDetailModel] {
        let realm = DBManager.shared.database
        let locale = GetFavoriteGamesLocaleDataSource(realm: realm)

        let mapper = GameDetailTransformer()

        let repository = GetFavoriteGamesRepository(localeDataSource: locale, mapper: mapper)
        return Interactor(repository: repository) as! U
    }

    // MARK: About
    func provideGetProfile<U: UseCase>(profile: ProfileModel? = nil) -> U where U.Request == Any, U.Response == ProfileModel {
        let dataSource = GetProfileDataSource()
        let mapper = ProfileTransformer()

        let repository = GetProfileRepository(dataSource: dataSource, mapper: mapper, profile: profile)
        return Interactor(repository: repository) as! U
    }

    func provideSaveProfile<U: UseCase>() -> U where U.Request == ProfileModel, U.Response == Bool {
        let dataSource = SaveProfileDataSource()
        let mapper = ProfileTransformer()

        let repository = SaveProfileRepository(dataSource: dataSource, mapper: mapper)
        return Interactor(repository: repository) as! U
    }

    func provideAboutApp<U: UseCase>() -> U where U.Request == Any, U.Response == String {
        let dataSource = GetAboutAppDataSource()

        let repository = GetAboutAppRepository(dataSource: dataSource)
        return Interactor(repository: repository) as! U
    }
    
    // MARK: Genre
    func provideGenres<U: UseCase>() -> U where U.Request == Any, U.Response == [GenreModel] {
        let remote = GetGenresRemoteDataSource()
        let mapper = GenresTransformer()

        let repository = GetGenresRepository(remoteDataSource: remote, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
    
    func provideGenreDetail<U: UseCase>() -> U where U.Request == Int, U.Response == GenreDetailModel {
        let remote = GetGenreDetailRemoteDataSource()
        let mapper = GenreDetailTransformer()
        
        let repository = GetGenreDetailRepository(remoteDataSource: remote, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
    
    // MARK: Store
    func provideStores<U: UseCase>() -> U where U.Request == Any, U.Response == [StoreModel] {
        let remote = GetStoresRemoteDataSource()
        let mapper = StoresTransformer()
        
        let repository = GetStoresRepository(remoteDataSource: remote, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
    
    func provideStoreDetail<U: UseCase>() -> U where U.Request == Int, U.Response == StoreDetailModel {
        let remote = GetStoreDetailRemoteDataSource()
        let mapper = StoreDetailTransformer()
        
        let repository = GetStoreDetailRepository(remoteDataSource: remote, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
    // swiftlint:enable force_cast
    
}
