//
//  GetGamesUseCaseSpec.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 08/06/22.
//

import Quick
import Nimble
import Legible
import CoreModule

@testable import GameModule

class GetGamesUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("get games") {
            var gameUseCase: Interactor<
                GameParamModel,
                GamesModel,
                GetGamesRepository<MockGetGamesRemoteDataSource, GamesTransformer>
            >!
            
            beforeEach {
                let dataSource = MockGetGamesRemoteDataSource()
                let transformer = GamesTransformer()
                let repository = GetGamesRepository(remoteDataSource: dataSource, mapper: transformer)
                gameUseCase = Interactor(repository: repository)
            }
            
            context("when the request param is valid") {
                itBehavesLike(CombinePublisher.self) {
                    gameUseCase
                        .execute(request: GameParamModel(page: 1))
                        .shouldFinish { gamesModel in
                            expect(gamesModel.games!.count).to(equal(8))
                        }
                        .before(timeout: 10)
                }
            }
            
            context("when the request param is not valid") {
                itBehavesLike(CombinePublisher.self) {
                    gameUseCase
                        .execute(request: GameParamModel(page: -1))
                        .shouldFail(with: MockServiceError.invalidRequest)
                        .before(timeout: 10)
                }
            }
        }
    }
    
}
