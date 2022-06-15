//
//  Router.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 25/05/22.
//

import UIKit
import GameModule
import AboutModule

protocol Router {
    
    typealias SortingOption = GameOrderingOption
    typealias GameId = Int
    typealias GameDetailModel = GameModule.GameDetailModel
    typealias GameParamModel = GameModule.GameParamModel
    typealias ProfileModel = AboutModule.ProfileModel
    typealias GenreId = Int
    typealias StoreId = Int

    func start()
    func routeToGames(caller: UIViewController, param: GameParamModel?)
    func routeToGameSorting(caller: UIViewController, selectedOption: SortingOption?, completion: @escaping (SortingOption?) -> Void)
    func routeToGameDetail(caller: UIViewController, id: GameId, gameDetail: GameDetailModel?)
    func routeToGenreDetail(caller: UIViewController, id: GenreId)
    func routeToStoreDetail(caller: UIViewController, id: StoreId)
    func routeToEditProfile(caller: UIViewController, profile: ProfileModel?)
    
}
