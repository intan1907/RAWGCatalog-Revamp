//
//  DateHelper.swift
//  GameModule
//
//  Created by Intan Nurjanah on 19/04/22.
//

import Foundation

struct DateHelper {
    
    static func dateParseToString(_ date: String, oldFormat: String, newFormat: String) -> String {
        let dateFormatter = DateFormatter()
        var newDateString = ""
        dateFormatter.dateFormat = oldFormat
        if let mydate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = newFormat
            newDateString = dateFormatter.string(from: mydate)
        }
        return newDateString
    }
    
}
