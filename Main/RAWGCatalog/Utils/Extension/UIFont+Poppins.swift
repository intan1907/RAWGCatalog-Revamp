//
//  UIFont+Poppins.swift
//  
//
//  Created by Intan Nurjanah on 19/04/22.
//

import UIKit

public extension UIFont {
    
    enum Poppins: String {
        case black = "Poppins-Black"
        case blackItalic = "Poppins-BlackItalic"
        case bold = "Poppins-Bold"
        case boldItalic = "Poppins-BoldItalic"
        case extraBold = "Poppins-ExtraBold"
        case extraBoldItalic = "Poppins-ExtraBoldItalic"
        case extraLight = "Poppins-ExtraLight"
        case extraLightItalic = "Poppins-ExtraLightItalic"
        case italic = "Poppins-Italic"
        case light = "Poppins-Light"
        case lightItalic = "Poppins-LightItalic"
        case medium = "Poppins-Medium"
        case mediumItalic = "Poppins-MediumItalic"
        case regular = "Poppins-Regular"
        case semiBold = "Poppins-SemiBold"
        case semiBoldItalic = "Poppins-SemiBoldItalic"
        case thin = "Poppins-Thin"
        case thinItalic = "Poppins-ThinItalic"
        
        public func font(ofSize: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
        }
    }
    
    static func loadCustomFont() {
        self.registerFont(withFilename: Poppins.black)
        self.registerFont(withFilename: Poppins.blackItalic)
        self.registerFont(withFilename: Poppins.bold)
        self.registerFont(withFilename: Poppins.boldItalic)
        self.registerFont(withFilename: Poppins.extraBold)
        self.registerFont(withFilename: Poppins.extraBoldItalic)
        self.registerFont(withFilename: Poppins.extraLight)
        self.registerFont(withFilename: Poppins.extraLightItalic)
        self.registerFont(withFilename: Poppins.italic)
        self.registerFont(withFilename: Poppins.light)
        self.registerFont(withFilename: Poppins.lightItalic)
        self.registerFont(withFilename: Poppins.medium)
        self.registerFont(withFilename: Poppins.mediumItalic)
        self.registerFont(withFilename: Poppins.regular)
        self.registerFont(withFilename: Poppins.semiBold)
        self.registerFont(withFilename: Poppins.semiBoldItalic)
        self.registerFont(withFilename: Poppins.thin)
        self.registerFont(withFilename: Poppins.thinItalic)
    }
    
    private static func registerFont(withFilename filename: Poppins) {
        let bundleURL = Bundle.main.url(forResource: "Fonts", withExtension: "bundle")
        
        guard let url = bundleURL, let bundle = Bundle(url: url) else {
            print("Failed load bundle")
            return }
        
        guard let pathForResourceString = bundle.path(forResource: filename.rawValue, ofType: "ttf") else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }

        guard let font = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }

        var errorRef: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &errorRef) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }

}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

public extension UIFont {
    
    @objc class func mySystemFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .medium:
            return UIFont.Poppins.medium.font(ofSize: ofSize)
        case .semibold:
            return UIFont.Poppins.semiBold.font(ofSize: ofSize)
        case .bold, .heavy, .black:
            return UIFont.Poppins.bold.font(ofSize: ofSize)
        default:
            return UIFont.Poppins.regular.font(ofSize: ofSize)
        }
    }
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.Poppins.regular.font(ofSize: size)
    }
    
    @objc class func myMediumSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.Poppins.medium.font(ofSize: size)
    }
    
    @objc class func mySemiBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.Poppins.semiBold.font(ofSize: size)
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.Poppins.italic.font(ofSize: size)
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.Poppins.bold.font(ofSize: size)
    }
    
    @objc convenience init?(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = UIFont.Poppins.regular.rawValue
        case "CTFontMediumUsage":
            fontName = UIFont.Poppins.medium.rawValue
        case "CTFontSemiboldUsage", "CTFontDemiUsage":
            fontName = UIFont.Poppins.semiBold.rawValue
        case "CTFontEmphasizedUsage", "CTFontBoldUsage", "CTFontHeavyUsage", "CTFontBlackUsage":
            fontName = UIFont.Poppins.bold.rawValue
        case "CTFontObliqueUsage":
            fontName = UIFont.Poppins.italic.rawValue
        default:
            fontName = UIFont.Poppins.regular.rawValue
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)
    }
    
    class func overrideDefaultTypography() {
        guard self == UIFont.self else { return }
        if let systemFontMethodWithWeight = class_getClassMethod(self, #selector(systemFont(ofSize: weight:))),
            let mySystemFontMethodWithWeight = class_getClassMethod(self, #selector(mySystemFont(ofSize: weight:))) {
            DispatchQueue.main.async {
                method_exchangeImplementations(systemFontMethodWithWeight, mySystemFontMethodWithWeight)
            }
        }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            DispatchQueue.main.async {
                method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
            }
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            DispatchQueue.main.async {
                method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
            }
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            DispatchQueue.main.async {
                method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
            }
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            DispatchQueue.main.async {
                method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
            }
        }
    }
}
