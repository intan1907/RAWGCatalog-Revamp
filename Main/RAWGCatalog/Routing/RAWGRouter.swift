//
//  RAWGRouter.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 01/06/22.
//

import UIKit

class RAWGRouter<Factory: ViewControllerFactory>: Router
where
    Factory.SortingOption == Router.SortingOption,
    Factory.GameId == Router.GameId,
    Factory.GameDetailModel == Router.GameDetailModel,
    Factory.GameParamModel == Router.GameParamModel,
    Factory.ProfileModel == Router.ProfileModel,
    Factory.GenreId == Router.GenreId,
    Factory.StoreId == Router.StoreId
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    private let factory: Factory
    private let rootNavigationController: UINavigationController
    
    init(_ navigationController: UINavigationController, factory: Factory) {
        self.rootNavigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let mainTab = self.factory.instantiateMainTabVC()
        
        self.rootNavigationController.setViewControllers([mainTab], animated: false)
        mainTab.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func routeToGames(caller: UIViewController, param: GameParamModel?) {
        let vc = self.factory.instantiateGamesVC(param: param)
        self.route(from: caller, to: vc)
    }
    
    func routeToGameSorting(caller: UIViewController, selectedOption: SortingOption?, completion: @escaping (SortingOption?) -> Void) {
        let vc = self.factory.instantiateGameSortingVC(selectedOption: selectedOption, completion: completion)
        self.show(vc: vc, from: caller)
    }
    
    func routeToGameDetail(caller: UIViewController, id: GameId, gameDetail: GameDetailModel?) {
        let vc = self.factory.instantiateGameDetailVC(id: id, gameDetail: gameDetail)
        self.route(from: caller, to: vc)
    }
    
    func routeToGenreDetail(caller: UIViewController, id: GenreId) {
        let vc = self.factory.instantiateGenreDetailVC(id: id)
        self.route(from: caller, to: vc)
    }
    
    func routeToStoreDetail(caller: UIViewController, id: StoreId) {
        let vc = self.factory.instantiateStoreDetailVC(id: id)
        self.route(from: caller, to: vc)
    }
    
    func routeToEditProfile(caller: UIViewController, profile: ProfileModel?) {
        let vc = self.factory.instantiateEditProfileVC(profile: profile)
        self.route(from: caller, to: vc)
    }
    
    private func route(from vc: UIViewController, to destinationVC: UIViewController) {
        destinationVC.hidesBottomBarWhenPushed = true
        vc.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    private func show(vc: UIViewController, from caller: UIViewController) {
        if let nav = vc.navigationController {
            caller.present(nav, animated: true)
        } else {
            caller.present(vc, animated: true)
        }
    }
}

class RAWGRouterManager {
    var router: Router?
    
    static var shared = RAWGRouterManager()
}
