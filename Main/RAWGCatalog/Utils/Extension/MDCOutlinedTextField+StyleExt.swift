//
//  MDCOutlinedTextField+StyleExt.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/10/21.
//

import UIKit
import MaterialComponents.MDCOutlinedTextField
import UIColor_Hex_Swift

public extension MDCOutlinedTextField {
    
    func setColor(titleColor: UIColor, normalOutlineColor: UIColor, activeOutlineColor: UIColor) {
        // title floating at the top of textfield
        self.setFloatingLabelColor(titleColor, for: .normal)
        self.setFloatingLabelColor(activeOutlineColor, for: .editing)
        
        // outline
        self.setOutlineColor(normalOutlineColor, for: .normal)
        self.setOutlineColor(activeOutlineColor, for: .editing)
    }
    
    // call when first creating textfield
    func configStarterAppearance(titleText: String? = nil, backgroundColor: UIColor = ColorConstant.colorBackground) {
        self.font = UIFont.Poppins.regular.font(ofSize: 14)
        self.leadingAssistiveLabel.font = UIFont.Poppins.regular.font(ofSize: 10.5)
        
        if let title = titleText {
            self.label.text = title
        } else {
            self.label.text = self.placeholder
        }
        
        // title placeholder before editing
        self.setNormalLabelColor(.lightGray, for: .normal)
        // default placeholder color
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: ColorConstant.colorLightGray])
        
        // assistive label
        self.setLeadingAssistiveLabelColor(ColorConstant.colorTextDarkGray, for: .editing)
        
        self.backgroundColor = backgroundColor
        
        // color text
        self.setTextColor(ColorConstant.colorText, for: .normal)
        self.setTextColor(ColorConstant.colorText, for: .editing)
        
        self.setToDefault()
    }
    
    func setToDefault() {
        self.setColor(titleColor: ColorConstant.colorTextDarkGray, normalOutlineColor: .lightGray, activeOutlineColor: ColorConstant.colorTeal)
        self.leadingAssistiveLabel.text = ""
        self.setLeadingAssistiveLabelColor(ColorConstant.colorTextDarkGray, for: .normal)
        self.setLeadingAssistiveLabelColor(ColorConstant.colorTextDarkGray, for: .editing)
    }
    
    func setToError(errorMessage: String) {
        let red = ColorConstant.colorPrimaryRed
        self.setColor(titleColor: red, normalOutlineColor: red, activeOutlineColor: ColorConstant.colorTeal)
        self.leadingAssistiveLabel.text = errorMessage
        self.setLeadingAssistiveLabelColor(red, for: .normal)
        self.setLeadingAssistiveLabelColor(red, for: .editing)
    }
}
