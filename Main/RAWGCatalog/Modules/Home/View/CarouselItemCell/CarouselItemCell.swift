//
//  GamesCarouselItemView.swift
//  GameModule
//
//  Created by Intan Nurjanah on 11/05/22.
//

import UIKit
import GameModule

class CarouselItemCell: UICollectionViewCell {
    
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var backgroundImg: UIImageView!
    var gradient: CAGradientLayer?
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = ColorConstant.colorBackground
        self.gradient = self.backgroundImg.setGradietColor(colorOne: .clear, colorTwo: ColorConstant.colorBlackTransparent)
        
        self.containerVw.roundedCorner(radius: 12)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient?.frame = self.bounds
    }
    
    private func configureView(game: GameModel) {
        self.backgroundImg.loadImage(fromImageUrl: game.imageUrl ?? "-")
        self.nameLbl.text = game.name ?? "-"
    }
}

extension CarouselItemCell {
    
    static func instantiate(collectionView: UICollectionView, indexPath: IndexPath, game: GameModel) -> CarouselItemCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselItemCell", for: indexPath) as? CarouselItemCell ?? CarouselItemCell()
        cell.configureView(game: game)
        return cell
    }
    
    static func getCalcultedCellSize() -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 32
        let height: CGFloat = (width * 9) / 16
        
        return CGSize(width: width, height: height)
    }
    
}
