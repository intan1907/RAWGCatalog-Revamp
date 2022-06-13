//
//  CustomButton.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/10/21.
//

import UIKit
import UIColor_Hex_Swift

public class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 8.0 // default radius
    @IBInspectable var borderWidth: CGFloat = 1.0 // default border width
    @IBInspectable var borderColor: UIColor = UIColor.clear // default border color
    
    public var bgColor: UIColor?
    public var textColor: UIColor?
    private var font: UIFont?
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
        
        if let givenFont = self.font {
            self.titleLabel?.font = givenFont
        }
    }
    
    public func setBorder(color: UIColor?) {
        self.borderColor = color ?? .clear
        self.layer.borderColor = self.borderColor.cgColor
    }
    
    public func setBorder(width: CGFloat) {
        self.borderWidth = width
        self.layer.borderWidth = self.borderWidth
    }
    
    public func setImage(icon: String, withTitle title: String = "") {
        self.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.setTitle(title, for: .normal)
    }
    
    public func configButton(bgColor: UIColor? = nil, textColor: UIColor? = nil, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil, font: UIFont? = nil) {
        self.bgColor = bgColor
        self.textColor = textColor
        self.setBorder(width: borderWidth ?? 0)
        self.setBorder(color: borderColor)
        self.font = font
        self.backgroundColor = self.bgColor
        self.tintColor = textColor
        self.setTitleColor(textColor, for: .normal)
    }
    
    public func setActiveDeactive(isActive: Bool) {
        self.isEnabled = isActive
        self.layer.borderWidth = isActive ? 1 : 0
        if isActive {
            self.backgroundColor = self.bgColor
            self.setTitleColor(self.textColor, for: .normal)
        } else {
            self.backgroundColor = self.bgColor?.withAlphaComponent(0.24)
            self.setTitleColor(UIColor("#7D7D7D"), for: .normal)
            self.layer.shadowColor = UIColor.clear.cgColor
        }
    }
}
