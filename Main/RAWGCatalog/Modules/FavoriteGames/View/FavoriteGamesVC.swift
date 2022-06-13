//
//  FavoriteGamesVC.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/06/22.
//

import UIKit
import Combine
import CoreModule
import GameModule

class FavoriteGamesVC: BaseVC {
    
    @IBOutlet weak var collectionVw: UICollectionView!
    private lazy var refreshControl = UIRefreshControl()
    
    var presenter: GetListPresenter<Any, GameDetailModel, Interactor<Any, [GameDetailModel], GetFavoriteGamesRepository<GetFavoriteGamesLocaleDataSource, GameDetailTransformer>>>!
    
    private var favoriteGames: [GameDetailModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configFavoriteGamesObservables()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load favorite game
        self.presenter.getList(request: nil)
    }
    
}

extension FavoriteGamesVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return GameCell.instantiate(collectionView: collectionView, indexPath: indexPath, game: self.favoriteGames[indexPath.item])
    }
    
}

extension FavoriteGamesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return GameCell.getCalculatedCellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
}

extension FavoriteGamesVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = self.favoriteGames[indexPath.item]
        RAWGRouterManager.shared.router?.routeToGameDetail(caller: self, id: game.id ?? 0, gameDetail: game)
    }
    
}

extension FavoriteGamesVC {
    
    private func configFavoriteGamesObservables() {
        self.presenter.$isLoading
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    if !self.refreshControl.isRefreshing {
                        self.showLoading(view: self.collectionVw)
                    }
                } else {
                    self.stopLoading()
                    if self.favoriteGames.isEmpty {
                        self.showMessage(view: self.collectionVw, message: TextConstant.emptyFavoriteGames)
                    }
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        self.presenter.$list
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] response in
                guard let self = self else { return }
                
                self.favoriteGames = response
                
                self.collectionVw.reloadData()
            }
            .store(in: &cancellables)
        
        self.presenter.$errorMessage
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] message in
                guard let self = self else { return }
                
                self.stopLoading()
                // data kosong
                if self.favoriteGames.isEmpty {
                    self.showMessage(view: self.collectionVw, message: message)
                } else {
                    // ada data
                    self.showTopMessage(message: message, error: true)
                    self.collectionVw.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureView() {
        // colors
        self.view.backgroundColor = ColorConstant.colorBackground
        self.collectionVw.backgroundColor = ColorConstant.colorBackground
        
        self.configLoadingViews()
        self.collectionVw.configure(fromController: self, cellName: ["GameCell"])
        
        // setup pull refresh
        self.refreshControl.tintColor = ColorConstant.colorGray
        self.refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        self.collectionVw.refreshControl = self.refreshControl
        
        self.collectionVw.reloadData()
    }
    
    @objc private func refreshData() {
        self.presenter.getList(request: nil)
    }
    
}
