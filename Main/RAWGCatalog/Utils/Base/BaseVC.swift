//
//  BaseVD.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 20/07/21.
//

import UIKit
import SwiftMessages

open class BaseVC: UIViewController {
    private var loadingViews: [LoadingView] = []
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if traitCollection.userInterfaceStyle == .light {
            return .lightContent
        }
        return .darkContent
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupColors()
    }
    
    open func configNavBar(backgroundColor: UIColor, shadowColor: UIColor) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.standardAppearance.shadowColor = shadowColor
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = shadowColor
    }
    
    open func configNavBarAttribut(tintColor: UIColor, titleColor: UIColor) {
        self.navigationController?.navigationBar.tintColor = tintColor
        let attribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.font: UIFont.Poppins.semiBold.font(ofSize: 16)]
        self.navigationController?.navigationBar.titleTextAttributes = attribute
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = attribute
        self.navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = attribute
    }
    
    open func configTabBar(backgroundColor: UIColor, shadowColor: UIColor) {
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.view.backgroundColor = backgroundColor
        self.tabBarController?.tabBar.barTintColor = backgroundColor
        
        self.tabBarController?.tabBar.standardAppearance.shadowColor = shadowColor
        if #available(iOS 15.0, *) {
            self.tabBarController?.tabBar.scrollEdgeAppearance?.shadowColor = shadowColor
        }
    }
    
    public func showLoading(idx: Int = 0, view: UIView, isTransluscent: Bool = true, bgColor: UIColor = ColorConstant.colorBackground) {
        loadingViews[idx].loadInView(view: view, isTransluscent: isTransluscent, bgColor: bgColor)
    }
    
    public func stopLoading(idx: Int = 0) {
        loadingViews[idx].stop()
    }
    
    public func showMessage(idx: Int = 0, view: UIView? = nil, image: String = IconConstant.warning, imageHeight: CGFloat = 64, message: String, bgColor: UIColor = ColorConstant.colorBackground, hintColor: UIColor = ColorConstant.colorTextDarkGray, showReloadBtn: Bool = false, reloadHandler: (() -> Void)? = nil) {
        var newMessage = message
        if message.contains("offline") {
            newMessage = TextConstant.noInternetErrorMessage
        }
        
        loadingViews[idx].showEmptyView(view: view ?? self.view, image: image, imageHeight: imageHeight, message: newMessage, bgColor: bgColor, hintColor: hintColor, hideReloadBtn: !showReloadBtn, reloadBtnHandler: reloadHandler)
    }
    
    open func configLoadingViews(count: Int = 1) {
        while self.loadingViews.count < count {
            self.loadingViews.append(LoadingView.instantiateFromNib())
        }
    }
}

// MARK: - Show Message
extension BaseVC {
    
    open func showTopMessage(message: String, error: Bool) {
        self.createMessage(message: message, error: error)
    }
    
    func createMessage(message: String, error: Bool) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureContent(
            title: "", body: message, iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "", buttonTapHandler: nil)
        view.tapHandler = { _ in
            SwiftMessages.hide()
        }
        view.configureDropShadow()
        view.button?.isHidden = true
        if error {
            view.configureTheme(.error, iconStyle: .light)
        } else {
            view.configureTheme(.success, iconStyle: .light)
        }
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.presentationStyle = .top
        config.duration = .seconds(seconds: TimeInterval(3.5))
        config.interactiveHide = true
        SwiftMessages.hideAll()
        SwiftMessages.show(config: config, view: view)
    }
}

// MARK: - color and theme
extension BaseVC {
    
    func setupColors() {
        // navbar
        self.configNavBar(backgroundColor: ColorConstant.colorNavBar, shadowColor: ColorConstant.colorNavBarShadow)
        self.configNavBarAttribut(tintColor: ColorConstant.colorText, titleColor: ColorConstant.colorText)
        
        // tabbar
        self.configTabBar(backgroundColor: ColorConstant.colorNavBar, shadowColor: ColorConstant.colorNavBarShadow)
        
        // view
        self.view.backgroundColor = ColorConstant.colorBackground
    }
    
}
