//
//  UIImageView+Ext.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 13/09/21.
//

import UIKit
import SDWebImage

public extension UIImageView {
    
    // loading
    func setLoad(isLoad: Bool, style: UIActivityIndicatorView.Style = .medium) {
        if isLoad {
            if subviews.count == 0 {
                let progress = UIActivityIndicatorView(style: style)
                progress.startAnimating()
                progress.color = ColorConstant.colorWhite
                self.backgroundColor = ColorConstant.colorLightGray
                self.addSubview(progress)
                
                let xConstraint = NSLayoutConstraint(item: progress, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
                
                let yConstraint = NSLayoutConstraint(item: progress, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
                progress.translatesAutoresizingMaskIntoConstraints = false
                self.addConstraint(xConstraint)
                self.addConstraint(yConstraint)
            }
        } else {
            self.backgroundColor = UIColor.clear
            self.subviews.forEach { $0.removeFromSuperview() }
        }
    }
    
    func loadImage(fromImageUrl imageUrl: String? = nil, withLocaleImage localeImage: Data? = nil, withAltImageUrl altImageUrl: String = IconConstant.notFound) {
        self.backgroundColor = ColorConstant.colorGray
        if let img = localeImage {
            self.image = UIImage.cropToBounds(image: UIImage(data: img) ?? (UIImage(named: IconConstant.notFound) ?? UIImage()), width: frame.width, height: frame.height)
        } else {
            self.setLoad(isLoad: true)
            self.sd_setImage(with: URL(string: imageUrl ?? "")) { (img, err, _, _) in
                self.setLoad(isLoad: false)
                let frame = self.frame
                if err == nil {
                    self.image = UIImage.cropToBounds(image: img ?? (UIImage(named: altImageUrl) ?? UIImage()), width: frame.width, height: frame.height)
                } else {
                    // show no image
                    self.image = UIImage.cropToBounds(image: (UIImage(named: altImageUrl) ?? UIImage()), width: frame.width, height: frame.height)
                }
            }
        }
    }
    
}
