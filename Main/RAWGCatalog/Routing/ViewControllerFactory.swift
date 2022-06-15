//
//  ViewControllerFactory.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 25/05/22.
//

import UIKit

protocol ViewControllerFactory {
    
    associatedtype SortingOption
    associatedtype GameId
    associatedtype GameDetailModel
    associatedtype GameParamModel
    associatedtype ProfileModel
    associatedtype GenreId
    associatedtype StoreId
    
    func instantiateMainTabVC() -> UIViewController
    func instantiateHomeVC() -> UIViewController
    func instantiateGamesVC(param: GameParamModel?) -> UIViewController
    func instantiateGameSortingVC(selectedOption: SortingOption?, completion: @escaping (SortingOption?) -> Void) -> UIViewController
    func instantiateGameDetailVC(id: GameId, gameDetail: GameDetailModel?) -> UIViewController
    func instantiateFavoriteGamesVC() -> UIViewController
    func instantiateAboutVC() -> UIViewController
    func instantiateGenreDetailVC(id: GenreId) -> UIViewController
    func instantiateStoreDetailVC(id: StoreId) -> UIViewController
    func instantiateEditProfileVC(profile: ProfileModel?) -> UIViewController
    
}
