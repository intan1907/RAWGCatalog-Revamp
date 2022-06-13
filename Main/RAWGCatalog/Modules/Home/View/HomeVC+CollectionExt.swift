//
//  HomeVC+CollectionExt.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 01/06/22.
//

import Foundation
import UIKit

extension HomeVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case self.carouselCollectionVw.tag:
            return self.featuredGames.count
        case self.genreCollectionVw.tag:
            return self.genres.count
        case self.gameCollectionVw.tag:
            return self.games.count
        case self.storeCollectionVw.tag:
            return self.stores.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case self.carouselCollectionVw.tag:
            return CarouselItemCell.instantiate(collectionView: collectionView, indexPath: indexPath, game: self.featuredGames[indexPath.item])
        case self.genreCollectionVw.tag:
            return GenreCell.instantiate(collectionView: collectionView, indexPath: indexPath, genre: self.genres[indexPath.item])
        case self.gameCollectionVw.tag:
            return GameCell.instantiate(collectionView: collectionView, indexPath: indexPath, game: self.games[indexPath.item])
        case self.storeCollectionVw.tag:
            return StoreCell.instantiate(collectionView: collectionView, indexPath: indexPath, store: self.stores[indexPath.item])
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard collectionView.tag == self.genreCollectionVw.tag else {
            return UICollectionReusableView()
        }
        
        return GenreHeaderView.instantiate(collectionView: collectionView, indexPath: indexPath)
    }
    
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case self.carouselCollectionVw.tag:
            return CarouselItemCell.getCalcultedCellSize()
        case self.genreCollectionVw.tag:
            return GenreCell.getCalculatedCellSize()
        case self.gameCollectionVw.tag:
            return GameCell.getCalculatedCellSize()
        case self.storeCollectionVw.tag:
            return StoreCell.getCalculatedCellSize()
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard collectionView.tag == self.genreCollectionVw.tag else {
            return .zero
        }
        
        let headerWidth = GenreHeaderView.getCalculatedGenreHeaderTitleWidth()
        return CGSize(width: headerWidth, height: self.genreCollectionVw.frame.height)
    }
    
}

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case self.carouselCollectionVw.tag:
            // route to detail game
            let gameId = self.featuredGames[indexPath.item].id ?? 0
            RAWGRouterManager.shared.router?.routeToGameDetail(caller: self, id: gameId, gameDetail: nil)
        case self.genreCollectionVw.tag:
            // route to detail genre
            let genreId = self.genres[indexPath.item].id ?? 0
            RAWGRouterManager.shared.router?.routeToGenreDetail(caller: self, id: genreId)
        case self.gameCollectionVw.tag:
            // route to detail game
            let gameId = self.games[indexPath.item].id ?? 0
            RAWGRouterManager.shared.router?.routeToGameDetail(caller: self, id: gameId, gameDetail: nil)
        case self.storeCollectionVw.tag:
            // route to detail store
            let storeId = self.stores[indexPath.item].id ?? 0
            RAWGRouterManager.shared.router?.routeToStoreDetail(caller: self, id: storeId)
        default:
            break
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.tag == self.carouselCollectionVw.tag else { return }
        
        let offset: CGFloat = scrollView.contentOffset.x / scrollView.frame.size.width
        let page: Int = Int(round(offset))
        self.currentPage = page
        self.pageControl.currentPage = page
    }
    
}

extension HomeVC {
    
    func configureCollection() {
        self.carouselCollectionVw.configure(fromController: self, cellName: ["CarouselItemCell"])
        self.carouselCollectionVw.tag = 101
        
        self.genreCollectionVw.configure(fromController: self, cellName: ["GenreCell"], headerSectionName: "GenreHeaderView")
        self.genreCollectionVw.tag = 102
        
        self.gameCollectionVw.configure(fromController: self, cellName: ["GameCell"])
        self.gameCollectionVw.tag = 103
        
        self.storeCollectionVw.configure(fromController: self, cellName: ["StoreCell"])
        self.storeCollectionVw.tag = 104
    }
    
    func configureCarouselCollectionHeight() {
        self.carouselCollectionHeightConst.constant = CarouselItemCell.getCalcultedCellSize().height + 1
    }
    
    func configureGameCollectionHeight() {
        let totalItem = self.games.count
        let estRow = Int(ceil(Double(totalItem) / 2))
        let verticalMargin: CGFloat = CGFloat((estRow - 1) * 12)
        let cellHeight: CGFloat = GameCell.getCalculatedCellSize().height
        
        let totalHeight = verticalMargin + (CGFloat(estRow) * cellHeight)
        self.gameCollectionHeightConst.constant = max(200, totalHeight)
    }
    
}

// carousel utilities
extension HomeVC {
    
    func startTimerScroll() {
        guard self.carouselTimer == nil && !self.games.isEmpty else { return }
        
        self.carouselTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc
    private func scrollToNextCell() {
        let cellSize = CGSize(width: self.carouselCollectionVw.frame.width, height: self.carouselCollectionVw.frame.height)
        let contentOffset = self.carouselCollectionVw.contentOffset
        let currentIndex = self.carouselCollectionVw.indexPathForItem(at: contentOffset)?.item
        
        if !self.featuredGames.isEmpty {
            if self.currentPage == self.featuredGames.count - 1 {
                self.currentPage = 0
                self.carouselCollectionVw.scrollRectToVisible(CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.height), animated: true)
            } else {
                // Scroll to next cell
                self.currentPage = (currentIndex ?? 0) + 1
                self.carouselCollectionVw.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
            }
        }
    }
    
    func invalidateTimer() {
        self.carouselTimer?.invalidate()
        self.carouselTimer = nil
    }
    
}
