//
//  GetGameDetailUseCaseSpec.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 08/06/22.
//

import Quick
import Nimble
import Legible
import CoreModule

@testable import GameModule

class GetGameDetailUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("get game detail") {
            context("when game exist only on remote data source") { [weak self] in
                guard let self = self else { return }
                itBehavesLike(CombinePublisher.self) {
                    self.makeGameDetailUseCase()
                        .execute(request: 5286)
                        .shouldFinish { gameDetail in
                            expect(gameDetail.id).to(equal(5286))
                        }
                        .before(timeout: 10)
                }
            }
            
            context("when game exist on remote and locale data source") { [weak self] in
                guard let self = self else { return }
                itBehavesLike(CombinePublisher.self) {
                    self.makeGameDetailUseCase()
                        .execute(request: 3498)
                        .shouldFinish { gameDetail in
                            expect(gameDetail.id).to(equal(3498))
                        }
                        .before(timeout: 10)
                }
            }
            
            context("when game does not exist on remote but exist on locale data source") { [weak self] in
                guard let self = self else { return }
                itBehavesLike(CombinePublisher.self) {
                    self.makeGameDetailUseCase()
                        .execute(request: 2000)
                        .shouldFinish { gameDetail in
                            expect(gameDetail.id).to(equal(2000))
                        }
                        .before(timeout: 10)
                }
            }
            
            context("when game does not exist on remote and locale data source") { [weak self] in
                guard let self = self else { return }
                itBehavesLike(CombinePublisher.self) {
                    self.makeGameDetailUseCase()
                        .execute(request: 1000)
                        .shouldFail(with: MockServiceError.notFound)
                        .before(timeout: 10)
                }
            }
            
            context("when game detail was passed to the repository, return passed game detail") { [weak self] in
                guard let self = self else { return }
                let passedGame = GameDetailModel(id: 500)
                itBehavesLike(CombinePublisher.self) {
                    self.makeGameDetailUseCase(gameDetail: passedGame)
                        .execute(request: 500)
                        .shouldFinish { gameDetail in
                            expect(gameDetail).to(equal(passedGame))
                        }
                        .before(timeout: 10)
                }
            }
        }
    }
    
}

// MARK: GetGameDetailUseCaseSpec Helper
extension GetGameDetailUseCaseSpec {
    
    func makeGameDetailUseCase(gameDetail: GameDetailModel? = nil)
    -> Interactor<
        Int,
        GameDetailModel,
        GetGameDetailRepository<
            MockGetFavoriteGamesLocaleDataSource,
            MockGetGameDetailRemoteDataSource,
            GameDetailTransformer
        >
    > {
        let locale = MockGetFavoriteGamesLocaleDataSource()
        let remote = MockGetGameDetailRemoteDataSource()
        
        let transformer = GameDetailTransformer()
        let repository = GetGameDetailRepository(localeDataSource: locale, remoteDataSource: remote, mapper: transformer, gameDetail: gameDetail)
        return Interactor(repository: repository)
    }
    
}

class GameDetailIsFavoriteSpec: GetGameDetailUseCaseSpec {
    
    override func spec() {
        describe("is game a favorite game") {
            context("when game is in favorites, isFavorite equal true") { [weak self] in
                guard let self = self else { return }
                itBehavesLike(CombinePublisher.self) {
                    self.makeGameDetailUseCase()
                        .execute(request: 3498)
                        .shouldFinish { gameDetail in
                            expect(gameDetail.isFavorite!).to(beTrue())
                        }
                        .before(timeout: 10)
                }
            }
            
            context("when game is not in favorites, isFavorite equal false") { [weak self] in
                guard let self = self else { return }
                itBehavesLike(CombinePublisher.self) {
                    self.makeGameDetailUseCase()
                        .execute(request: 5286)
                        .shouldFinish { gameDetail in
                            expect(gameDetail.isFavorite!).to(beFalse())
                        }
                        .before(timeout: 10)
                }
            }
        }
    }
    
}
