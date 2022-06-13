//
//  GameDetailModelSpec.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 07/06/22.
//

import Quick
import Nimble

@testable import GameModule

class GameDetailModelCopySpec: QuickSpec {
    
    override func spec() {
        describe("game detail model copy") {
            var gameDetail: GameDetailModel!
            var gameDetailCopy: GameDetailModel!
            
            beforeEach {
                gameDetail = GameDetailModel(id: 10, name: "Limbo", isFavorite: false)
                gameDetailCopy = gameDetail.copy() as? GameDetailModel
            }
            
            it("has difference reference with the original game detail") {
                expect(gameDetailCopy === gameDetail).to(beFalse())
            }
            
        }
    }
    
}

class GameDetailModelFormattedMetacriticSpec: QuickSpec {
    
    override func spec() {
        describe("get formatted metacritic") {
            var gameDetail: GameDetailModel!
            
            beforeEach {
                gameDetail = GameDetailModel()
            }
            
            context("when metacritic has some value") {
                beforeEach {
                    gameDetail.metacritic = 96
                }
                
                it("return the metacritic") {
                    expect(gameDetail.getFormattedMetacritic()).to(equal("96"))
                }
            }
            
            context("when metacritic value is nil") {
                it("return not rated") {
                    expect(gameDetail.getFormattedMetacritic()).to(equal("Not rated"))
                }
            }
        }
    }
    
}

class GameDetailModelArrayStoresSpec: QuickSpec {
    
    override func spec() {
        describe("get array stores") {
            var gameDetail: GameDetailModel!
            
            beforeEach {
                gameDetail = GameDetailModel()
            }
            
            context("when stores has some value") {
                beforeEach {
                    gameDetail.stores = "store 1, store 2, store 3"
                }
                
                it("return non-empty array of store") {
                    let stores = gameDetail.getArrayStores()
                    expect(stores).toNot(beEmpty())
                    expect(stores.count).to(equal(3))
                }
            }
            
            context("when stores value is nil") {
                it("return empty array of store") {
                    expect(gameDetail.getArrayStores()).to(beEmpty())
                }
            }
        }
    }
    
}

class GameDetailModelFormattedPlaytimeSpec: QuickSpec {
    
    override func spec() {
        describe("get formatted playtime") {
            var gameDetail: GameDetailModel!
            
            beforeEach {
                gameDetail = GameDetailModel()
            }
            
            context("when playtime has some value") {
                beforeEach {
                    gameDetail.playtime = 85
                }
                
                it("return formatted playtime") {
                    expect(gameDetail.getFormattedPlaytime()).to(equal("85 minute(s)"))
                }
            }
            
            context("when playtime value is nil") {
                it("return default value") {
                    expect(gameDetail.getFormattedPlaytime()).to(equal("Unknown"))
                }
            }
        }
    }
    
}

class GameDetailModelRatingCategorySpec: QuickSpec {
    
    override func spec() {
        describe("get rating category with emoji") {
            var gameDetail: GameDetailModel!
            
            beforeEach {
                gameDetail = GameDetailModel()
            }
            
            context("when it is exceptional") {
                beforeEach {
                    gameDetail.ratingCategory = "Exceptional"
                }
                
                it("return rating category with emoji") {
                    expect(gameDetail.getRatingCategoryWithEmoji()).to(equal("Exceptional \u{1F3AF}"))
                }
            }
            
            context("when it is recommended") {
                beforeEach {
                    gameDetail.ratingCategory = "Recommended"
                }
                
                it("return rating category with emoji") {
                    expect(gameDetail.getRatingCategoryWithEmoji()).to(equal("Recommended \u{1F44D}"))
                }
            }
            
            context("when it is meh") {
                beforeEach {
                    gameDetail.ratingCategory = "Meh"
                }
                
                it("return rating category with emoji") {
                    expect(gameDetail.getRatingCategoryWithEmoji()).to(equal("Meh \u{1F611}"))
                }
            }
            
            context("when it is skip") {
                beforeEach {
                    gameDetail.ratingCategory = "Skip"
                }
                
                it("return rating category with emoji") {
                    expect(gameDetail.getRatingCategoryWithEmoji()).to(equal("Skip \u{1F6AB}"))
                }
            }
            
            context("when it is not listed") {
                beforeEach {
                    gameDetail.ratingCategory = "other"
                }
                
                it("return only the rating category") {
                    expect(gameDetail.getRatingCategoryWithEmoji()).to(equal("other"))
                }
            }
            
            context("when rating category value is nil") {
                it("return empty description") {
                    expect(gameDetail.getRatingCategoryWithEmoji()).to(equal("-"))
                }
            }
        }
    }
    
}
