//
//  UpdateFavoriteGameUseCaseSpec.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 08/06/22.
//

import Quick
import Nimble
import Legible
import CoreModule

@testable import GameModule

class UpdateFavoriteGameUseCaseSpec: QuickSpec {

    override func spec() {
        var updateGameUseCase: Interactor<
            GameDetailModel,
            Bool,
            UpdateFavoriteGameRepository<
                MockGetFavoriteGamesLocaleDataSource,
                GameDetailTransformer
            >
        >!
        
        beforeEach {
            let locale = MockGetFavoriteGamesLocaleDataSource()
            let transformer = GameDetailTransformer()
            
            let repository = UpdateFavoriteGameRepository(localeDataSource: locale, mapper: transformer)
            updateGameUseCase = Interactor(repository: repository)
        }
        
        context("when success to update game detail into favorite, isFavorite equal true") {
            let game = GameDetailModel(id: 1000)
            game.isFavorite = true
            
            itBehavesLike(CombinePublisher.self) {
                updateGameUseCase
                    .execute(request: game)
                    .shouldFinish(expectedValue: true)
                    .before(timeout: 10)
            }
        }
        
        context("when success to unfavorite game detail, isFavorite equal false") {
            let game = GameDetailModel(id: 2000)
            game.isFavorite = false
            
            itBehavesLike(CombinePublisher.self) {
                updateGameUseCase
                    .execute(request: game)
                    .shouldFinish(expectedValue: false)
                    .before(timeout: 10)
            }
        }
        
        context("when update favorite game into favorite, isFavorite equal true") {
            let game = GameDetailModel(id: 3498)
            game.isFavorite = true
            
            itBehavesLike(CombinePublisher.self) {
                updateGameUseCase
                    .execute(request: game)
                    .shouldFinish(expectedValue: true)
                    .before(timeout: 10)
            }
        }
        
        context("when fail to unfavorite game detail, return error") {
            let nonExistGameDetail = GameDetailModel(id: 1500)
            nonExistGameDetail.isFavorite = false
            
            itBehavesLike(CombinePublisher.self) {
                updateGameUseCase
                    .execute(request: nonExistGameDetail)
                    .shouldFail(with: MockDatabaseError.notFound)
                    .before(timeout: 10)
            }
        }
        
    }
    
}
