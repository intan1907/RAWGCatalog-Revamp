//
//  HomeVC.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 01/06/22.
//

import UIKit
import Combine
import CoreModule
import GameModule
import GenreModule
import StoreModule

class HomeVC: BaseVC {
    
    @IBOutlet weak var scrollVw: UIScrollView!
    lazy var refreshControl = UIRefreshControl()
    @IBOutlet weak var contentVw: UIView!
    
    @IBOutlet weak var carouselContainerVw: UIView!
    @IBOutlet weak var carouselCollectionVw: UICollectionView!
    @IBOutlet weak var carouselCollectionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var genreCollectionVw: UICollectionView!
    
    @IBOutlet weak var gameCollectionVw: UICollectionView!
    @IBOutlet weak var gameCollectionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var seeAllGamesBtnContainerVw: UIView!
    @IBOutlet weak var seeAllGamesBtn: CustomButton!
    
    @IBOutlet weak var storeCollectionVw: UICollectionView!
    
    @IBOutlet weak var appLogoImg: UIImageView!
    
    var presenter: HomePresenter<
        Interactor<GameParamModel, GamesModel, GetGamesRepository<GetGamesRemoteDataSource, GamesTransformer>>,
        Interactor<Any, [GenreModel], GetGenresRepository<GetGenresRemoteDataSource, GenresTransformer>>,
        Interactor<Any, [StoreModel], GetStoresRepository<GetStoresRemoteDataSource, StoresTransformer>>
    >!
    
    private var cancellables: Set<AnyCancellable> = []
    
    var featuredGames: [GameModel] = []
    var genres: [GenreModel] = []
    var games: [GameModel] = []
    var stores: [StoreModel] = []
    
    // carousel's variable
    var carouselTimer: Timer?
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configInitialViews()
        self.setupObservable()
        self.doCallApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configInitialViews() {
        // setup custom navbar
        if let navigationBar = self.navigationController?.navigationBar {
            let customNavTitleVw = HomeNavigationBarTitle.instantiateFromNib()

            navigationBar.topItem?.titleView = customNavTitleVw
        }
        
        // setup colors
        self.view.backgroundColor = ColorConstant.colorBackground
        self.scrollVw.backgroundColor = ColorConstant.colorBackground
        self.contentVw.backgroundColor = ColorConstant.colorBackground
        self.carouselCollectionVw.backgroundColor = ColorConstant.colorBackground
        self.genreCollectionVw.backgroundColor = ColorConstant.colorBackground
        self.gameCollectionVw.backgroundColor = ColorConstant.colorBackground
        self.storeCollectionVw.backgroundColor = ColorConstant.colorBackground
        self.seeAllGamesBtn.configButton(bgColor: ColorConstant.colorTeal, textColor: ColorConstant.colorWhite, font: UIFont.Poppins.semiBold.font(ofSize: 14))
        self.appLogoImg.tintColor = ColorConstant.colorTexGray
        
        // setup collection views and loading views
        self.configLoadingViews(count: 4)
        self.configureCollection()
        
        self.pageControl.isHidden = true
        self.pageControl.isUserInteractionEnabled = false
        
        self.appLogoImg.image = UIImage(named: IconConstant.gamepad)?.withRenderingMode(.alwaysTemplate)
        
        // setup pull refresh
        self.refreshControl.tintColor = ColorConstant.colorGray
        self.refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        self.scrollVw.refreshControl = self.refreshControl
    }
    
    @IBAction func seeAllGamesBtnAction() {
        // route to all games
        RAWGRouterManager.shared.router?.routeToGames(caller: self, param: nil)
    }
    
}

extension HomeVC {
    
    private func setupObservable() {
        self.setupLoadingAndErrorObservable()
        
        self.presenter.$featuredGames
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] gamesResponse in
                guard let self = self else { return }
                self.featuredGames = gamesResponse ?? []
                self.configureCarouselCollectionHeight()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.stopLoading(idx: 0)
                    if self.featuredGames.isEmpty {
                        self.showMessage(idx: 0, view: self.carouselCollectionVw, message: TextConstant.emptyFeaturedGames)
                        self.pageControl.isHidden = true
                        self.invalidateTimer()
                    } else {
                        self.pageControl.isHidden = false
                        self.pageControl.numberOfPages = self.featuredGames.count
                        self.startTimerScroll()
                    }
                    self.carouselCollectionVw.reloadData()
                }
            }
            .store(in: &cancellables)
        
        self.presenter.$genres
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] genresResponse in
                guard let self = self else { return }
                self.genres = genresResponse ?? []
                self.stopLoading(idx: 1)
                if genresResponse?.isEmpty ?? true {
                    self.showMessage(idx: 1, view: self.genreCollectionVw, message: TextConstant.emptyGenres)
                }
                self.genreCollectionVw.reloadData()
            }
            .store(in: &cancellables)
        
        self.presenter.$games
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] gamesResponse in
                guard let self = self else { return }
                self.games = gamesResponse ?? []
                self.configureGameCollectionHeight()
                self.stopLoading(idx: 2)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if self.games.isEmpty {
                        self.showMessage(idx: 2, view: self.gameCollectionVw, message: TextConstant.emptyGames)
                        self.seeAllGamesBtnContainerVw.isHidden = true
                    } else {
                        self.seeAllGamesBtnContainerVw.isHidden = false
                    }
                    
                    self.gameCollectionVw.reloadData()
                }
            }
            .store(in: &cancellables)
        
        self.presenter.$stores
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] storesResponse in
                guard let self = self else { return }
                self.stores = storesResponse ?? []
                if self.stores.isEmpty {
                    self.showMessage(idx: 3, view: self.storeCollectionVw, message: TextConstant.emptyStores)
                } else {
                    self.stopLoading(idx: 3)
                }
                self.storeCollectionVw.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupLoadingAndErrorObservable() {
        self.presenter.$errorMessage
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] error in
                guard let self = self else { return }
                
                let errors = error.components(separatedBy: "_")
                let caller = errors.first ?? ""
                let message = errors.count > 1 ? errors[1] : caller
                
                switch caller {
                case TextConstant.featuredGamesRequest:
                    self.stopLoading(idx: 0)
                    self.pageControl.isHidden = true
                    self.showMessage(idx: 0, view: self.carouselContainerVw, message: message)
                    self.invalidateTimer()
                case TextConstant.genresRequest:
                    self.stopLoading(idx: 1)
                    self.showMessage(idx: 1, view: self.genreCollectionVw, message: message)
                case TextConstant.gamesRequest:
                    self.stopLoading(idx: 2)
                    self.games = []
                    self.gameCollectionVw.reloadData()
                    self.configureGameCollectionHeight()
                    self.seeAllGamesBtnContainerVw.isHidden = true
                    self.showMessage(idx: 2, view: self.gameCollectionVw, message: message)
                case TextConstant.storesRequest:
                    self.stopLoading(idx: 3)
                    self.showMessage(idx: 3, view: self.storeCollectionVw, message: message)
                default:
                    self.stopLoading()
                    // show error message that cover the entire view
                    self.showMessage(message: message, showReloadBtn: true) {
                        self.doCallApi()
                    }
                }
            }
            .store(in: &cancellables)
        
        self.presenter.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if !isLoading {
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
    
    private func doCallApi() {
        if !self.refreshControl.isRefreshing {
            self.showLoading(idx: 0, view: self.carouselCollectionVw)
            self.showLoading(idx: 1, view: self.genreCollectionVw)
            self.showLoading(idx: 2, view: self.gameCollectionVw)
            self.showLoading(idx: 3, view: self.storeCollectionVw)
        }
        
        self.presenter.getFeaturedGames()
        self.presenter.getGenres()
        self.presenter.getGames()
        self.presenter.getStores()
    }
    
    @objc
    func refreshData() {
        self.doCallApi()
    }
    
}
