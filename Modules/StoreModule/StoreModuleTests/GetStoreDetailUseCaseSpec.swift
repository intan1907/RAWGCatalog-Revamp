//
//  GetStoreDetailUseCaseSpec.swift
//  StoreModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Quick
import Nimble
import Legible
import CoreModule

@testable import StoreModule

class GetStoreDetailUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("get store detail") {
            var getStoreDetailUseCase: Interactor<
                Int,
                StoreDetailModel,
                GetStoreDetailRepository<
                    MockGetStoreDetailRemoteDataSource,
                    StoreDetailTransformer
                >
            >!
            
            beforeEach {
                let remote = MockGetStoreDetailRemoteDataSource()
                let transformer = StoreDetailTransformer()
                
                let repository = GetStoreDetailRepository(remoteDataSource: remote, mapper: transformer)
                getStoreDetailUseCase = Interactor(repository: repository)
            }
            
            context("when store detail exist on data source") {
                itBehavesLike(CombinePublisher.self) {
                    getStoreDetailUseCase
                        .execute(request: 1)
                        .shouldFinish { storeDetail in
                            expect(storeDetail.id).to(equal(1))
                        }
                        .before(timeout: 10)
                }
            }
            
            context("when store detail does not exist on data source") {
                itBehavesLike(CombinePublisher.self) {
                    getStoreDetailUseCase
                        .execute(request: 35)
                        .shouldFail(with: MockServiceError.notFound)
                }
            }
        }
    }
    
}
