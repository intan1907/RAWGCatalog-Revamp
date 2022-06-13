//
//  BaseGamesVC.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 05/06/22.
//

import UIKit
import Combine
import GameModule

open class BaseGamesVC: BaseVC {
    
    @IBOutlet weak var gamesCollectionVw: UICollectionView!
    @IBOutlet weak var gamesCollectionHeightConst: NSLayoutConstraint!
    var refreshControl = UIRefreshControl()
    
    var showLoadMore: Bool {
        return true
    }
    
    var games: [GameModel] = []
    
    var currentPage: Int = 1
    var totalData: Int = 0
    var isPossibleToLoadMore = false
    
    var cancellables: Set<AnyCancellable> = []
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configInitialViews()
        self.showLoading(view: self.view)
        self.doCallApi()
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    open func configInitialViews() {
        self.view.backgroundColor = ColorConstant.colorBackground
        self.gamesCollectionVw.backgroundColor = ColorConstant.colorBackground
        
        self.configLoadingViews()
        self.gamesCollectionVw.registerLoadMoreCell()
        
        // setup pull refresh
        self.refreshControl.tintColor = ColorConstant.colorGray
        self.refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        if self.showLoadMore {
            self.gamesCollectionVw.refreshControl = self.refreshControl
        }
    }
    
    open func doCallApi() {
        
    }
    
    @objc
    private func refreshData() {
        self.currentPage = 1
        self.totalData = 0
        
        self.doCallApi()
    }
    
    func configureGamesCollectionHeight(topInset: CGFloat = 12, spaceInterLines: CGFloat = 12, bottomInset: CGFloat = 16) {
        let totalItem = self.games.count
        let estRow = Int(ceil(Double(totalItem) / 2))
        let verticalMargin: CGFloat = topInset + (CGFloat(estRow - 1) * spaceInterLines) + bottomInset
        let cellHeight: CGFloat = GameCell.getCalculatedCellSize().height
        
        let totalHeight = verticalMargin + (CGFloat(estRow) * cellHeight)
        self.gamesCollectionHeightConst.constant = max(200, totalHeight)
    }
    
}

extension BaseGamesVC: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.isPossibleToLoadMore && self.showLoadMore) ? 2 : 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return self.games.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            return LoadMoreCell.instantiate(collectionView, cellForRowAt: indexPath)
        }
        return GameCell.instantiate(collectionView: collectionView, indexPath: indexPath, game: self.games[indexPath.row])
    }
    
}

extension BaseGamesVC: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: UIScreen.main.bounds.width - (16 + 16), height: 72)
        }
        return GameCell.getCalculatedCellSize()
    }
    
}

extension BaseGamesVC: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        RAWGRouterManager.shared.router?.routeToGameDetail(caller: self, id: self.games[indexPath.row].id ?? 0, gameDetail: nil)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = self.gamesCollectionVw.contentOffset.y + self.gamesCollectionVw.frame.size.height
        let content = floor(self.gamesCollectionVw.contentSize.height)
        if offset >= content {
            // load more item
            guard self.games.count < self.totalData else { return }
            self.doCallApi()
        }
    }
    
}
