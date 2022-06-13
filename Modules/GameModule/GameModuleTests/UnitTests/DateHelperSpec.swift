//
//  DateHelperSpec.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 07/06/22.
//

import Quick
import Nimble

@testable import GameModule

class DateHelperSpec: QuickSpec {
    
    override func spec() {
        describe("date parse to string with old date format = yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
            let dateString = "2022-02-15T08:25:07.360Z"
            let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            context("when new date format is dd-MM-yyyy") {
                let dateString2 = "15-02-2022"
                let dateFormat2 = "dd-MM-yyyy"
                let parsedDate = DateHelper.dateParseToString(dateString, oldFormat: dateFormat, newFormat: dateFormat2)
                expect(parsedDate).to(contain(dateString2))
            }
            
            context("when new date format is dd/MM/yyyy") {
                let dateString2 = "15/02/2022"
                let dateFormat2 = "dd/MM/yyyy"
                let parsedDate = DateHelper.dateParseToString(dateString, oldFormat: dateFormat, newFormat: dateFormat2)
                expect(parsedDate).to(contain(dateString2))
            }
            
            context("when new date format is d MMMM yyyy") {
                let dateString2 = "15 February 2022"
                let dateFormat2 = "d MMMM yyyy"
                let parsedDate = DateHelper.dateParseToString(dateString, oldFormat: dateFormat, newFormat: dateFormat2)
                expect(parsedDate).to(contain(dateString2))
            }
            
            context("when new date format is d MMM yyyy") {
                let dateString2 = "15 Feb 2022"
                let dateFormat2 = "d MMM yyyy"
                let parsedDate = DateHelper.dateParseToString(dateString, oldFormat: dateFormat, newFormat: dateFormat2)
                expect(parsedDate).to(contain(dateString2))
            }
        }
    }

}
