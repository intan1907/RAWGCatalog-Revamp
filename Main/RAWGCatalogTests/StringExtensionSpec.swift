//
//  StringExtensionSpec.swift
//  RAWGCatalogTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Quick
import Nimble

@testable import RAWGCatalog

class StringExtensionSpec: QuickSpec {

    override func spec() {
        describe("string extension") {
            context("is it valid alphabet") {
                it("is valid alphabet") {
                    expect(" ".isValidAlphabet).to(beTrue())
                    expect("Intan Nurjanah".isValidAlphabet).to(beTrue())
                }
                
                it("is invalid alphabet") {
                    expect("5 April 2022".isValidAlphabet()).to(beFalse())
                    expect("intan3951@gmail.com".isValidAlphabet()).to(beFalse())
                }
            }
            
            context("is it valid email") {
                it("is valid email") {
                    expect("intan.nur@gmail.com".isValidEmail()).to(beTrue())
                    expect("intan_nur@gmail.com".isValidEmail()).to(beTrue())
                    expect("intan+nur@gmail.com".isValidEmail()).to(beTrue())
                    expect("intan3951@gmail.com".isValidEmail()).to(beTrue())
                    expect("intan3951@odt.id".isValidEmail()).to(beTrue())
                }
                
                it("is invalid email") {
                    expect("Intan Nurjanah".isValidEmail()).to(beFalse())
                    expect("@gmail.com".isValidEmail()).to(beFalse())
                    expect("intan@gmail".isValidEmail()).to(beFalse())
                    expect("intan@gmail.".isValidEmail()).to(beFalse())
                }
            }
            
            context("is it an empty content") {
                it("is empty content") {
                    expect("-".isEmptyContent()).to(beTrue())
                    expect("".isEmptyContent()).to(beTrue())
                }
                
                it("is not empty content") {
                    expect("some string".isEmptyContent()).to(beFalse())
                }
            }
        }
    }
    
}
