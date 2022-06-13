//
//  UITextField+ValidationExt.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/10/21.
//

import UIKit

public extension UITextField {
    
    // disable whitespace in prefix
    func shouldChangeCharacters(in range: NSRange, replacementString string: String) -> Bool {
        // inspect space input
        if string == " " {
            if range.location == 0 {
                let newString = (self.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
            } else if self.text?.last == " " {
                self.text = (self.text as NSString?)?.replacingCharacters(in: range, with: " ")
                if let pos = self.position(from: self.beginningOfDocument, offset: range.location + 1) {
                    // updates the text caret to reflect the programmatic change to the textField
                    self.selectedTextRange = self.textRange(from: pos, to: pos)
                    return false
                }
            }
        }
        return true
    }
    
}
