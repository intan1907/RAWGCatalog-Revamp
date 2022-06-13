//
//  MDCOutlinedTextArea+StyleExt.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/10/21.
//

import UIKit
import MaterialComponents.MDCOutlinedTextArea
import UIColor_Hex_Swift

public extension MDCOutlinedTextArea {
    
    func setColor(titleColor: UIColor, normalOutlineColor: UIColor, activeOutlineColor: UIColor) {
        // title floating at the top of textfield
        self.setFloatingLabel(titleColor, for: .normal)
        self.setFloatingLabel(activeOutlineColor, for: .editing)
        
        // outline
        self.setOutlineColor(normalOutlineColor, for: .normal)
        self.setOutlineColor(activeOutlineColor, for: .editing)
    }
    
    // call when first creating textfield
    func configStarterAppearance(titleText: String? = nil, fontSize: CGFloat = 14) {
        self.textView.font = UIFont.Poppins.regular.font(ofSize: fontSize)
        self.leadingAssistiveLabel.font = UIFont.Poppins.regular.font(ofSize: 10.5)
        
        if let title = titleText {
            self.label.text = title
        } else {
            self.label.text = self.placeholder
        }
        
        // title placeholder before editing
        self.setNormalLabel(.lightGray, for: .normal)
        // default placeholder color
        self.placeholderColor = ColorConstant.colorLightGray
        
        // assistive label
        self.setLeadingAssistiveLabel(ColorConstant.colorTextDarkGray, for: .editing)
        
        self.backgroundColor = ColorConstant.colorBackground
        
        // color text
        self.setTextColor(ColorConstant.colorText, for: .normal)
        self.setTextColor(ColorConstant.colorText, for: .editing)
                
        self.setToDefault()
    }
    
    func setToDefault() {
        self.setColor(titleColor: ColorConstant.colorTextDarkGray, normalOutlineColor: .lightGray, activeOutlineColor: ColorConstant.colorTeal)
        self.leadingAssistiveLabel.text = ""
        self.setLeadingAssistiveLabel(ColorConstant.colorTextDarkGray, for: .normal)
        self.setLeadingAssistiveLabel(ColorConstant.colorTextDarkGray, for: .editing)
    }
    
    func setToError(errorMessage: String) {
        let red = ColorConstant.colorPrimaryRed
        self.setColor(titleColor: red, normalOutlineColor: red, activeOutlineColor: ColorConstant.colorTeal)
        self.leadingAssistiveLabel.text = errorMessage
        self.setLeadingAssistiveLabel(red, for: .normal)
        self.setLeadingAssistiveLabel(red, for: .editing)
    }
    
}
