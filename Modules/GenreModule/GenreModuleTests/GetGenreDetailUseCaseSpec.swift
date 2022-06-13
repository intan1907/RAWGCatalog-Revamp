//
//  GetGenreDetailUseCaseSpec.swift
//  GenreModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Quick
import Nimble
import Legible
import CoreModule

@testable import GenreModule

class GetGenreDetailUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("get genre detail") {
            var getGenreDetailUseCase: Interactor<
                Int,
                GenreDetailModel,
                GetGenreDetailRepository<
                    MockGetGenreDetailRemoteDataSource,
                    GenreDetailTransformer
                >
            >!
            
            beforeEach {
                let remote = MockGetGenreDetailRemoteDataSource()
                let transformer = GenreDetailTransformer()
                
                let repository = GetGenreDetailRepository(remoteDataSource: remote, mapper: transformer)
                getGenreDetailUseCase = Interactor(repository: repository)
            }
            
            context("when genre detail exist on data source") {
                itBehavesLike(CombinePublisher.self) {
                    getGenreDetailUseCase
                        .execute(request: 1)
                        .shouldFinish { genreDetail in
                            expect(genreDetail.id).to(equal(1))
                        }
                        .before(timeout: 10)
                }
            }
            
            context("when genre detail does not exist on data source") {
                itBehavesLike(CombinePublisher.self) {
                    getGenreDetailUseCase
                        .execute(request: 52)
                        .shouldFail(with: MockServiceError.notFound)
                }
            }
        }
        
    }
    
}
