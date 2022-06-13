//
//  GetFavoriteGamesUseCaseSpec.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 08/06/22.
//

import Quick
import Nimble
import Legible
import CoreModule

@testable import GameModule

class GetFavoriteGamesUseCaseSpec: QuickSpec {

    override func spec() {
        describe("get favorite games") {
            context("when data exist") { [weak self] in
                guard let self = self else { return }
                
                itBehavesLike(CombinePublisher.self) {
                    self.makeGetFavoriteUseCase(isDataEmpty: false)
                        .execute(request: nil)
                        .shouldFinish { favorites in
                            expect(favorites.count).to(equal(2))
                        }
                        .before(timeout: 10)
                }
            }
            
            context("when data is empty") { [weak self] in
                guard let self = self else { return }
                
                itBehavesLike(CombinePublisher.self) {
                    self.makeGetFavoriteUseCase(isDataEmpty: true)
                        .execute(request: nil)
                        .shouldFinish { favorites in
                            expect(favorites.count).to(equal(0))
                        }
                }
            }
        }
    }

}

// MARK: GetFavoriteGamesUseCaseSpec Helper
extension GetFavoriteGamesUseCaseSpec {
    
    private func makeGetFavoriteUseCase(isDataEmpty: Bool)
    -> Interactor<
        Any,
        [GameDetailModel],
        GetFavoriteGamesRepository<
            MockGetFavoriteGamesLocaleDataSource,
            GameDetailTransformer
        >
    > {
        let locale = MockGetFavoriteGamesLocaleDataSource(isDataEmpty: isDataEmpty)
        let transformer = GameDetailTransformer()
        
        let repository = GetFavoriteGamesRepository(localeDataSource: locale, mapper: transformer)
        return Interactor(repository: repository)
    }
    
}
