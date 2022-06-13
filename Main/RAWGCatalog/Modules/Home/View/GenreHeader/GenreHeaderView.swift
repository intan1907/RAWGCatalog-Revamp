//
//  GenreHeaderView.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 03/06/22.
//

import UIKit

class GenreHeaderView: UICollectionReusableView {

    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var headerTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = ColorConstant.colorBackground
        self.containerVw.backgroundColor = ColorConstant.colorBackgroundInverted
        
        self.containerVw.roundedCorner(radius: 8)
        
        self.rotateHeaderTitle()
    }
    
    private func rotateHeaderTitle() {
        let angle = -CGFloat.pi / 2
        self.headerTitleLbl.transform = CGAffineTransform(rotationAngle: angle)
    }
    
}

extension GenreHeaderView {
    
    static func instantiate(collectionView: UICollectionView, indexPath: IndexPath) -> GenreHeaderView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GenreHeaderView", for: indexPath) as? GenreHeaderView ?? GenreHeaderView()
    }
    
    static func getCalculatedGenreHeaderTitleWidth() -> CGFloat {
        let labelWidth: CGFloat = "Genres".sizeOfString(usingFont: UIFont.Poppins.bold.font(ofSize: 16)).width + 2
        let horizontalMargin: CGFloat = 16 + 4 + 4
        return labelWidth + horizontalMargin
    }
    
}
