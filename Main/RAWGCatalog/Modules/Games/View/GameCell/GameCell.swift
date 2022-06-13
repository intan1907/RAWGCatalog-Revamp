//
//  GameCell.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 02/06/22.
//

import UIKit
import GameModule

class GameCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingContainerVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set color
        self.backgroundColor = ColorConstant.colorBackground
        self.contentView.backgroundColor = ColorConstant.colorBackground
        // corner radius of game image background
        self.backgroundImg.roundedCorner(radius: 12)
    }
    
    private func configureView(game: GameModel) {
        self.backgroundImg.loadImage(fromImageUrl: game.imageUrl, withLocaleImage: game.image)
        self.nameLbl.text = game.name ?? "-"
        self.configureRating(rating: game.rating ?? 0)
    }
    
    private func configureRating(rating: Double) {
        if rating > 0 {
            // clean subviews
            self.ratingContainerVw.subviews.forEach { vw in
                vw.removeFromSuperview()
            }
            
            let ratingVw = RatingView.instantiateFromNib(rating: rating, widthLimit: GameCell.getCalculatedCellSize().width)
            self.ratingContainerVw.addSubview(ratingVw)
            ratingVw.bindToSuperView(edgeInsets: .zero)
            
            self.ratingContainerVw.isHidden = false
        } else {
            self.ratingContainerVw.isHidden = true
        }
    }

}

extension GameCell {
    
    static func instantiate(collectionView: UICollectionView, indexPath: IndexPath, game: GameModel) -> GameCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCell ?? GameCell()
        cell.configureView(game: game)
        return cell
    }
    
    private static var imageWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let horizontalMargin: CGFloat = 16 + 12 + 16
        let totalWidth = (screenWidth - horizontalMargin) / 2
        return totalWidth
    }
    
    static func getCalculatedCellSize(withTitle gameTitle: String = "Game") -> CGSize {
        let verticalMargin: CGFloat = 6
        let nameLblHeight: CGFloat = gameTitle.sizeOfString(usingFont: UIFont.Poppins.medium.font(ofSize: 14)).height
        let ratingVwHeight: CGFloat = RatingView.ratingHeight
        let totalHeight = GameCell.imageWidth + nameLblHeight + ratingVwHeight + verticalMargin
        let intHeight = Int(ceil(totalHeight))
        return CGSize(width: GameCell.imageWidth, height: CGFloat(intHeight))
    }
    
}
