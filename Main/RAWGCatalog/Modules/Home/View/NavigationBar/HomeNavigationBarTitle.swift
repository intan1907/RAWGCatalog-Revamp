//
//  HomeNavigationBarTitle.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 11/05/22.
//

import UIKit

class HomeNavigationBarTitle: UIView {
    
    @IBOutlet weak var appLogoImg: UIImageView!
    
    private func configureView() {
        let image = UIImage(named: IconConstant.gamepadFill)?
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(ColorConstant.colorText)
        self.appLogoImg.image = image
    }
    
}

extension HomeNavigationBarTitle {
    
    static func instantiateFromNib() -> HomeNavigationBarTitle {
        let vw = UINib(nibName: "HomeNavigationBarTitle", bundle: Bundle.main).instantiate(withOwner: nil, options: [:])[0] as? HomeNavigationBarTitle ?? HomeNavigationBarTitle()
        vw.configureView()
        return vw
    }
    
}
