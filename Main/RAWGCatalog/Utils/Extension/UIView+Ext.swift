//
//  UIView+Ext.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 03/04/22.
//

import UIKit

extension UIView {
    
    public func roundedCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    public func setBorder(width: CGFloat, color: UIColor, radius: CGFloat? = nil) {
        if let radius = radius {
            self.roundedCorner(radius: radius)
        }
        
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    @discardableResult
    public func bindToSuperView(edgeInsets: UIEdgeInsets) -> [NSLayoutConstraint] {

        guard let superview = self.superview else {
            return []
        }

        translatesAutoresizingMaskIntoConstraints = false

        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-left-[subview]-right-|",
            options: [],
            metrics: [
                "left": edgeInsets.left,
                "right": edgeInsets.right
            ],
            views: [
                "subview": self
            ]
        )

        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-top-[subview]-bottom-|",
            options: [],
            metrics: [
                "top": edgeInsets.top,
                "bottom": edgeInsets.bottom
            ],
            views: [
                "subview": self
            ]
        )

        superview.addConstraints(horizontalConstraints + verticalConstraints)

        return horizontalConstraints + verticalConstraints
    }
    
    @discardableResult
    public func setGradietColor(colorOne: UIColor, colorTwo: UIColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0, 1]
        
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }
    
}
