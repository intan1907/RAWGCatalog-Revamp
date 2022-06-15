//
//  UIKitViewControllerFactory.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 01/06/22.
//

import UIKit
import CoreModule
import GameModule
import GenreModule
import AboutModule
import StoreModule

class UIKitViewControllerFactory: ViewControllerFactory {
    
    typealias SortingOption = GameOrderingOption
    typealias GameId = Int
    typealias GameDetailModel = GameModule.GameDetailModel
    typealias GameParamModel = GameModule.GameParamModel
    typealias ProfileModel = AboutModule.ProfileModel
    typealias GenreId = Int
    typealias StoreId = Int
    
    func instantiateMainTabVC() -> UIViewController {
        let tabVC = UITabBarController()
        UITabBar.appearance().tintColor = ColorConstant.colorText
        
        // items
        let homeVC = self.instantiateHomeVC()
        let rootHomeVC = UINavigationController(rootViewController: homeVC)
        rootHomeVC.configureTabItem(rootVC: rootHomeVC, tabTitle: "Home", imageName: IconConstant.home, selectedImageName: IconConstant.homeFill)
        
        let favoritesVC = self.instantiateFavoriteGamesVC()
        let rootFavoritesVC = UINavigationController(rootViewController: favoritesVC)
        rootFavoritesVC.configureTabItem(rootVC: rootFavoritesVC, tabTitle: "Favorites", imageName: IconConstant.bookmark, selectedImageName: IconConstant.bookmarkFill)
        
        let aboutVC = self.instantiateAboutVC()
        let rootAboutVC = UINavigationController(rootViewController: aboutVC)
        rootAboutVC.configureTabItem(rootVC: rootAboutVC, tabTitle: "About", imageName: IconConstant.info, selectedImageName: IconConstant.infoFill)

        tabVC.viewControllers = [rootHomeVC, rootFavoritesVC, rootAboutVC]
        return tabVC
    }
    
    func instantiateHomeVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as? HomeVC ?? HomeVC()
        
        let di = Injection()
        let gameUseCase: Interactor<
            GameParamModel,
            GamesModel,
            GetGamesRepository<GetGamesRemoteDataSource, GamesTransformer>
        > = di.provideGames()
        
        let genreUseCase: Interactor<
            Any,
            [GenreModel],
            GetGenresRepository<GetGenresRemoteDataSource, GenresTransformer>
        > = di.provideGenres()
        
        let storeUseCase: Interactor<
            Any,
            [StoreModel],
            GetStoresRepository<GetStoresRemoteDataSource, StoresTransformer>
        > = di.provideStores()
        
        vc.presenter = HomePresenter(gameUseCase: gameUseCase, genreUseCase: genreUseCase, storeUseCase: storeUseCase)
        return vc
    }
    
    func instantiateGamesVC(param: GameParamModel?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Games", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as? GamesVC ?? GamesVC()
        
        let gamesUseCase: Interactor<
            GameParamModel,
            GamesModel,
            GetGamesRepository<GetGamesRemoteDataSource, GamesTransformer>
        > = Injection().provideGames()
        
        vc.presenter = GamesPresenter(useCase: gamesUseCase, param: param)
        return vc
    }
    
    func instantiateGameSortingVC(selectedOption: SortingOption?, completion: @escaping (SortingOption?) -> Void) -> UIViewController {
        let storyboard = UIStoryboard(name: "GameSorting", bundle: Bundle.main)
        let nav = storyboard.instantiateInitialViewController() as? UINavigationController ?? UINavigationController()
        nav.modalPresentationStyle = .fullScreen
        
        let vc = nav.topViewController as? GameSortingVC ?? GameSortingVC()
        vc.presenter = GameSortingPresenter(selectedOption: selectedOption)
        vc.completion = completion
        
        return vc
    }
    
    func instantiateGameDetailVC(id: GameId, gameDetail: GameDetailModel?) -> UIViewController {
        let storyboard = UIStoryboard(name: "GameDetail", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as? GameDetailVC ?? GameDetailVC()
        
        let di = Injection()
        let gameDetailUseCase: Interactor<
            Int,
            GameModule.GameDetailModel,
            GetGameDetailRepository<
                GetFavoriteGamesLocaleDataSource,
                GetGameDetailRemoteDataSource,
                GameDetailTransformer
            >
        > = di.provideGameDetail(gameDetail: gameDetail)
        
        let updateFavoriteUseCase: Interactor<
            GameDetailModel,
            Bool,
            UpdateFavoriteGameRepository<
                GetFavoriteGamesLocaleDataSource,
                GameDetailTransformer
            >
        > = di.provideUpdateFavoriteGame()
        
        vc.presenter = GameDetailPresenter(gameDetailUseCase: gameDetailUseCase, updateFavoriteGameUseCase: updateFavoriteUseCase, id: id)
        return vc
    }
    
    func instantiateFavoriteGamesVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "FavoriteGames", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as? FavoriteGamesVC ?? FavoriteGamesVC()
        
        let favoriteGamesUseCase: Interactor<
            Any,
            [GameDetailModel],
            GetFavoriteGamesRepository<GetFavoriteGamesLocaleDataSource, GameDetailTransformer>
        > = Injection().provideFavoriteGames()
        
        vc.presenter = GetListPresenter(useCase: favoriteGamesUseCase)
        return vc
    }
    
    func instantiateAboutVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "About", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as? AboutVC ?? AboutVC()
        
        let di = Injection()
        let getProfileUseCase: Interactor<
            Any,
            ProfileModel,
            GetProfileRepository<GetProfileDataSource, ProfileTransformer>
        > = di.provideGetProfile()
        
        let getAboutAppUseCase: Interactor<
            Any,
            String,
            GetAboutAppRepository<GetAboutAppDataSource>
        > = di.provideAboutApp()
        
        vc.presenter = AboutPresenter(profileUseCase: getProfileUseCase, aboutAppUseCase: getAboutAppUseCase)
        return vc
    }
    
    func instantiateGenreDetailVC(id: GenreId) -> UIViewController {
        let storyboard = UIStoryboard(name: "GenreDetail", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as? GenreDetailVC ?? GenreDetailVC()
        
        let di = Injection()
        let getGenreUseCase: Interactor<
            Int,
            GenreDetailModel,
            GetGenreDetailRepository<GetGenreDetailRemoteDataSource, GenreDetailTransformer>
        > = di.provideGenreDetail()
        
        let gamesUseCase: Interactor<
            GameParamModel,
            GamesModel,
            GetGamesRepository<GetGamesRemoteDataSource, GamesTransformer>
        > = di.provideGames()
        
        vc.presenter = GenreDetailPresenter(genreUseCase: getGenreUseCase, gamesUseCase: gamesUseCase, genreId: id)
        return vc
    }
    
    func instantiateStoreDetailVC(id: StoreId) -> UIViewController {
        let storyboard = UIStoryboard(name: "StoreDetail", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as? StoreDetailVC ?? StoreDetailVC()
        
        let di = Injection()
        let storeDetailUseCase: Interactor<
            Int,
            StoreDetailModel,
            GetStoreDetailRepository<GetStoreDetailRemoteDataSource, StoreDetailTransformer>
        > = di.provideStoreDetail()
        
        let gamesUseCase: Interactor<
            GameParamModel,
            GamesModel,
            GetGamesRepository<GetGamesRemoteDataSource, GamesTransformer>
        > = di.provideGames()
        
        vc.presenter = StoreDetailPresenter(storeUseCase: storeDetailUseCase, gamesUseCase: gamesUseCase, storeId: id)
        return vc
    }
    
    func instantiateEditProfileVC(profile: ProfileModel?) -> UIViewController {
        let storyboard = UIStoryboard(name: "EditProfile", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as? EditProfileVC ?? EditProfileVC()
        
        let di = Injection()
        let getProfileUseCase: Interactor<
            Any,
            ProfileModel,
            GetProfileRepository<GetProfileDataSource, ProfileTransformer>
        > = di.provideGetProfile()
        
        let saveProfileUseCase: Interactor<
            ProfileModel,
            Bool,
            SaveProfileRepository<SaveProfileDataSource, ProfileTransformer>
        > = di.provideSaveProfile()
        
        vc.presenter = EditProfilePresenter(getProfileUseCase: getProfileUseCase, saveProfileUseCase: saveProfileUseCase)
        return vc
    }
    
}
