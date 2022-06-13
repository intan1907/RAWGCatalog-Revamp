//
//  GetStoresUseCaseSpec.swift
//  StoreModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Quick
import Nimble
import Legible
import CoreModule

@testable import StoreModule

class GetStoresUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("get stores") {
            var getStoresUseCase: Interactor<
                Any,
                [StoreModel],
                GetStoresRepository<
                    MockGetStoresRemoteDataSource,
                    StoresTransformer
                >
            >!
            
            beforeEach {
                let remote = MockGetStoresRemoteDataSource()
                let transformer = StoresTransformer()
                
                let repository = GetStoresRepository(remoteDataSource: remote, mapper: transformer)
                getStoresUseCase = Interactor(repository: repository)
            }
            
            context("when data exist on data source") {
                itBehavesLike(CombinePublisher.self) {
                    getStoresUseCase
                        .execute(request: nil)
                        .shouldFinish(afterReceiving: { stores in
                            expect(stores.count).to(equal(10))
                        })
                        .before(timeout: 10)
                }
            }
        }
    }
    
}
