//
//  RatingView.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 02/06/22.
//

import UIKit

class RatingView: UIView {

    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var ratingStackWidthConst: NSLayoutConstraint!
    @IBOutlet weak var ratingLbl: UILabel!
    
    private let maxRating: Int = 5
    
    private let starSize: CGFloat = 16
    static let ratingHeight: CGFloat = 4 + 4 + 16
    
    private var decimalRemainder: Double {
        return self.rating.truncatingRemainder(dividingBy: 1)
    }
    
    private var intRemainder: Int {
        if self.decimalRemainder > 0.2 {
            return 4 - Int(rating)
        }
        return 5 - Int(rating)
    }
    
    private var ratingStackWidth: CGFloat {
        let starsWidth: CGFloat = CGFloat(self.maxRating) * self.starSize
        let horizontalMargin: CGFloat = CGFloat((self.maxRating - 1) * 6)
        return starsWidth + horizontalMargin
    }
    
    private var ratingViewTotalWidth: CGFloat {
        let ratingWidth: CGFloat = self.ratingStackWidth
        let ratingLblWidth: CGFloat = stringRating.sizeOfString(usingFont: UIFont.Poppins.medium.font(ofSize: 12)).width
        let totalWidth: CGFloat = ratingWidth + CGFloat(8) + ratingLblWidth
        return totalWidth
    }
    
    private var rating: Double = 0
    private var widthLimit: Double = 0
    
    private var stringRating: String {
        return String(format: "%.1f", self.rating)
    }
    
    private func configureView(rating: Double, widthLimit: CGFloat) {
        // colors
        self.backgroundColor = ColorConstant.colorBackground
        
        self.rating = rating
        self.widthLimit = widthLimit
        
        self.ratingLbl.text = self.stringRating
        
        self.configureRatingView()
    }
    
    private func configureRatingView() {
        // clean stack view
        self.ratingStack.arrangedSubviews.forEach { [weak self] vw in
            self?.ratingStack.removeArrangedSubview(vw)
            vw.removeFromSuperview()
        }
        
        guard self.widthLimit > self.ratingViewTotalWidth else {
            self.ratingStackWidthConst.constant = self.starSize
            
            let filledStar = self.createStar(withStarIcon: IconConstant.starFill)
            self.ratingStack.addArrangedSubview(filledStar)
            return
        }
        
        self.ratingStackWidthConst.constant = self.ratingStackWidth
        
        // arranged subview
        if self.rating >= 1 {
            for _ in 1...Int(rating) {
                let star = self.createStar(withStarIcon: IconConstant.starFill)
                self.ratingStack.addArrangedSubview(star)
            }
        }
        
        if self.decimalRemainder > 0.2 {
            let star = self.createStar(withStarIcon: IconConstant.starHalf)
            self.ratingStack.addArrangedSubview(star)
        }
        
        if self.intRemainder > 0 {
            for _ in 1...(self.intRemainder) {
                let star = self.createStar(withStarIcon: IconConstant.star)
                self.ratingStack.addArrangedSubview(star)
            }
        }
    }
    
    private func createStar(withStarIcon icon: String) -> UIImageView {
        let star = UIImageView(frame: .zero)
        star.tintColor = ColorConstant.colorYellow
        star.image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
        
        star.translatesAutoresizingMaskIntoConstraints = false
        // add constraint
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: star, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.starSize),
            NSLayoutConstraint(item: star, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.starSize)
        ])
        return star
    }
    
}

extension RatingView {
    
    public static func instantiateFromNib(rating: Double, widthLimit: CGFloat) -> RatingView {
        let view = UINib(nibName: "RatingView", bundle: Bundle.main).instantiate(withOwner: nil, options: [:])[0] as? RatingView ?? RatingView()
        view.configureView(rating: rating, widthLimit: widthLimit)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }
    
}
