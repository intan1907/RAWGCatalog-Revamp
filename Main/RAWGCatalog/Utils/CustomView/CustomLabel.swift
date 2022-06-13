//
//  CustomLabel.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 05/05/22.
//

import UIKit

public class CustomLabel: UILabel {
    
    private var textColorStyle: Int = 1
    
    @IBInspectable var style: Int {
        get {
            return self.textColorStyle
        }
        set {
            self.textColorStyle = newValue
            
            // 1 for primary
            // 2 for secondary
            // 3 for inverted from primary
            // 4 for footer gray
            
            switch newValue {
            case 2:
                self.textColor = ColorConstant.colorTextDarkGray
            case 3:
                self.textColor = ColorConstant.colorTextInverted
            case 4:
                self.textColor = ColorConstant.colorTexGray
            default:
                self.textColor = ColorConstant.colorText
            }
        }
    }
    
}
