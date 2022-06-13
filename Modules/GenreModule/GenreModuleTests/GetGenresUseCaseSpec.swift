//
//  GetGenresUseCaseSpec.swift
//  GenreModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Quick
import Nimble
import Legible
import CoreModule

@testable import GenreModule

class GetGenresUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("get genres") {
            var getGenreUseCase: Interactor<
                Any,
                [GenreModel],
                GetGenresRepository<
                    MockGetGenresRemoteDataSource,
                    GenresTransformer
                >
            >!
            
            beforeEach {
                let remote = MockGetGenresRemoteDataSource()
                let transformer = GenresTransformer()
                
                let repository = GetGenresRepository(remoteDataSource: remote, mapper: transformer)
                getGenreUseCase = Interactor(repository: repository)
            }
            
            context("when data exist on data source") {
                itBehavesLike(CombinePublisher.self) {
                    getGenreUseCase
                        .execute(request: nil)
                        .shouldFinish(afterReceiving: { genres in
                            expect(genres.count).to(equal(19))
                        })
                        .before(timeout: 10)
                }
            }
        }
    }
    
}
