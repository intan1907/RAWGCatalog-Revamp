//
//  LoadMoreCell.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 13/09/21.
//

import UIKit

public class LoadMoreCell: UICollectionViewCell {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()

        self.loadingView.tintColor = ColorConstant.colorGray
        self.backgroundColor = ColorConstant.colorBackground
        self.contentView.backgroundColor = ColorConstant.colorBackground
    }
    
}

public extension LoadMoreCell {
    
    static func instantiate(_ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath) -> LoadMoreCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as? LoadMoreCell ?? LoadMoreCell()
        cell.loadingView.startAnimating()
        return cell
    }
    
}
