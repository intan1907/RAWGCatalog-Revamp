//
//  UINavigationController+TabBarItemExt.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 03/04/22.
//

import UIKit

extension UINavigationController {
    
    public func configureTabItem(rootVC: UINavigationController, tabTitle: String, imageName: String, selectedImageName: String, color: UIColor = ColorConstant.colorText) {
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont.Poppins.semiBold.font(ofSize: 10)]
        UITabBarItem.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        let tabImage = UIImage(named: imageName)?.withTintColor(color, renderingMode: .alwaysTemplate)
        let tabSelectedImage = UIImage(named: selectedImageName)?.withTintColor(color, renderingMode: .alwaysTemplate)
        
        rootVC.tabBarItem = UITabBarItem(title: tabTitle, image: tabImage, selectedImage: tabSelectedImage)
    }
    
}
