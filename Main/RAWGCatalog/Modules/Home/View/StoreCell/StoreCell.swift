//
//  StoreCell.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 03/06/22.
//

import UIKit
import StoreModule

class StoreCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set color
        self.backgroundColor = ColorConstant.colorBackground
        self.contentView.backgroundColor = ColorConstant.colorBackground
        // corner radius of store image background
        self.backgroundImg.roundedCorner(radius: 12)
    }
    
    private func configureView(store: StoreModel) {
        self.backgroundImg.loadImage(fromImageUrl: store.imageUrl)
        self.nameLbl.text = store.name ?? ""
    }

}

extension StoreCell {
    
    static func instantiate(collectionView: UICollectionView, indexPath: IndexPath, store: StoreModel) -> StoreCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCell", for: indexPath) as? StoreCell ?? StoreCell()
        cell.configureView(store: store)
        return cell
    }
    
    private static func cellHeight() -> CGFloat {
        let gridHeight: CGFloat = 264
        let totalHeight = (gridHeight - 12) / 2
        return totalHeight
    }
    
    static func getCalculatedCellSize(withTitle storeName: String = "Steam") -> CGSize {
        let verticalMargin: CGFloat = 6
        let nameLblHeight: CGFloat = storeName.sizeOfString(usingFont: UIFont.Poppins.medium.font(ofSize: 14)).height
        
        let cellHeight = StoreCell.cellHeight()
        let imageSize: CGFloat = cellHeight - (verticalMargin + nameLblHeight)
        
        return CGSize(width: imageSize, height: cellHeight)
    }
    
}
