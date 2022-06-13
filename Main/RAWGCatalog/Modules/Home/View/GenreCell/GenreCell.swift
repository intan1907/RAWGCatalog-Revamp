//
//  GenreCell.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 02/06/22.
//

import UIKit
import GenreModule

class GenreCell: UICollectionViewCell {

    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set color
        self.backgroundColor = ColorConstant.colorBackground
        self.contentView.backgroundColor = ColorConstant.colorBackground
        self.containerVw.backgroundColor = ColorConstant.colorGrayTransparent
        
        // rounded
        self.containerVw.roundedCorner(radius: 8)
    }
    
    private func configureView(genre: GenreModel) {
        self.backgroundImg.loadImage(fromImageUrl: genre.imageUrl)
        
        self.nameLbl.text = genre.name?.uppercased() ?? "-"
    }

}

extension GenreCell {
    
    static func instantiate(collectionView: UICollectionView, indexPath: IndexPath, genre: GenreModel) -> GenreCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as? GenreCell ?? GenreCell()
        cell.configureView(genre: genre)
        return cell
    }
    
    static func getCalculatedCellSize() -> CGSize {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let imageHeight: CGFloat = 72
        
        let totalWidth = (screenWidth - 16) / 2
        return CGSize(width: totalWidth, height: imageHeight)
    }
    
}
