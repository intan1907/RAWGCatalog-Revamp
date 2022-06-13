//
//  GameOrderingModel.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 07/06/22.
//

import Quick
import Nimble

@testable import GameModule

class GameOrderingOptionSpec: QuickSpec {

    override func spec() {
        describe("title") {
            var option: GameOrderingOption!
            
            context("when it is added") {
                beforeEach {
                    option = .added
                }
                
                it("return title") {
                    expect(option.title).to(equal("Default"))
                }
            }
            
            context("when it is name") {
                beforeEach {
                    option = .name
                }
                
                it("return title") {
                    expect(option.title).to(equal("Name"))
                }
            }
            
            context("when it is updated") {
                beforeEach {
                    option = .updated
                }
                
                it("return title") {
                    expect(option.title).to(equal("Latest Updated"))
                }
            }
            
            context("when it is released") {
                beforeEach {
                    option = .released
                }
                
                it("return title") {
                    expect(option.title).to(equal("Latest Released"))
                }
            }
            
            context("when it is rating") {
                beforeEach {
                    option = .rating
                }
                
                it("return title") {
                    expect(option.title).to(equal("Highest Rating"))
                }
            }
            
            context("when it is metacritic") {
                beforeEach {
                    option = .metacritic
                }
                
                it("return title") {
                    expect(option.title).to(equal("Highest Metacritic"))
                }
            }
        }
    }

}
