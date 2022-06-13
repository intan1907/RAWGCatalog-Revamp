//
//  ColorConstant.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 26/04/22.
//

import SwiftUI
import UIKit
import UIColor_Hex_Swift

public struct ColorConstant {
    
    public static let colorBackground = UIColor(named: "ColorBackgroundAdaptive") ?? UIColor("#2F3841")
    public static let colorBackgroundInverted = UIColor(named: "ColorBackgroundInvertedAdaptive") ?? UIColor.black
    
    public static let colorNavBar = UIColor(named: "ColorNavigationBarAdaptive") ?? UIColor.white
    public static let colorNavBarShadow = UIColor(named: "ColorNavigationBarShadowAdaptive") ?? UIColor("#E0E0E0")
    
    public static let colorText = UIColor(named: "ColorTextAdaptive") ?? UIColor.black
    public static let colorTextDarkGray = UIColor(named: "ColorTextDarkGrayAdaptive") ?? UIColor.init(white: 0.333, alpha: 1)
    public static let colorTextInverted = UIColor(named: "ColorTextInvertedAdaptive") ?? UIColor.white
    public static let colorTexGray = UIColor.gray
    
    public static let colorBlackTransparent = UIColor(named: "ColorBlackTransparent") ?? UIColor.black.withAlphaComponent(0.5)
    
    public static let colorGray = UIColor.systemGray
    public static let colorLightGray = UIColor.lightGray
    public static let colorGrayTransparent = UIColor(named: "ColorGrayTransparentAdaptive") ?? UIColor("#D1D1D5")
    
    public static let colorTeal = UIColor(named: "ColorTeal") ?? UIColor("#00ACB5")
    
    public static let colorPrimaryRed = UIColor("#EB5757")
    
    public static let colorYellow = UIColor("#F0B827")
    
    public static let colorWhite = UIColor.white
}
