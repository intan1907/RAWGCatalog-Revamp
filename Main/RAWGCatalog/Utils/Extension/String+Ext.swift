//
//  String+WithBullets.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 05/07/21.
//

import UIKit

public extension String {
    
    static func stringWithBullets(
        stringList: [String],
        font: UIFont,
        bullet: String = "\u{2022}",
        indentation: CGFloat = 12,
        lineSpacing: CGFloat = 1,
        paragraphSpacing: CGFloat = 1,
        textColor: UIColor = ColorConstant.colorText,
        bulletColor: UIColor = .red
    ) -> NSAttributedString {
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        
        let bulletAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: bulletColor
        ]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for idx in 0..<stringList.count {
            var formattedString = "\(bullet)\t\(stringList[idx])"
            if idx != stringList.count - 1 {
                formattedString += "\n"
            }
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle: paragraphStyle],
                range: NSRange(location: 0, length: attributedString.length)
            )
            
            attributedString.addAttributes(
                textAttributes,
                range: NSRange(location: 0, length: attributedString.length)
            )
            
            let string: NSString = NSString(string: formattedString)
            let rangeForBullet: NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        
        return bulletList
    }
    
    func isEmptyContent() -> Bool {
        return (self.isEmpty || self == "-")
    }
    
    func isValidAlphabet() -> Bool {
        let REGEX = "(^[a-zA-Z ]*$)"
        let matches = NSPredicate(format: "SELF MATCHES %@", REGEX)
        let result =  matches.evaluate(with: self)
        return result
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func htmlAttributedString(fontFamily: String, pointSize: CGFloat, color: UIColor) -> NSAttributedString? {
        let modifiedFont = String(format: "<span style=\"font-family: '\(fontFamily)'; font-size: \(pointSize)\">%@</span>", self)
        guard let data = modifiedFont.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        html.addAttributes([NSAttributedString.Key.foregroundColor: color], range: NSRange(location: 0, length: html.length))
        return html
    }
    
}

public extension NSMutableAttributedString {
    
    func trimmedAttributedString() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        let location = string.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
    
}
