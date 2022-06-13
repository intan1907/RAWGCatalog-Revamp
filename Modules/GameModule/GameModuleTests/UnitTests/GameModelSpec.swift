//
//  GameModelSpec.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 07/06/22.
//

import Quick
import Nimble

@testable import GameModule

class GameModelSpec: QuickSpec {
    
    override func spec() {
        describe("get formatted rating") {
            var model: GameModel!
            
            beforeEach {
                model = GameModel()
            }
            
            context("when rating value has 3 decimal digits") {
                beforeEach {
                    model.rating = 4.492
                }
                
                it("return 2 decimal digits") {
                    expect(model.getFormattedRating()).to(equal("4.49"))
                }
            }
            
            context("when rating value has 1 decimal digit") {
                beforeEach {
                    model.rating = 4.7
                }
                
                it("return 2 decimal digits") {
                    expect(model.getFormattedRating()).to(equal("4.70"))
                }
            }
            
            context("when rating value is nil") {
                it("return empty value description") {
                    expect(model.getFormattedRating()).to(equal("Not rated"))
                }
            }
        }
    }
    
}
