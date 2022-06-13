//
//  SaveProfileUseCaseSpec.swift
//  AboutModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Quick
import Nimble
import Legible
import CoreModule

@testable import AboutModule

class SaveProfileUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("save profile") {
            var saveProfileUseCase: Interactor<
                ProfileModel,
                Bool,
                SaveProfileRepository<
                    MockSaveProfileDataSource,
                    ProfileTransformer
                >
            >!
            
            beforeEach {
                let dataSource = MockSaveProfileDataSource()
                let transformer = ProfileTransformer()
                
                let repository = SaveProfileRepository(dataSource: dataSource, mapper: transformer)
                saveProfileUseCase = Interactor(repository: repository)
            }
            
            context("with non-nil profile model param") {
                itBehavesLike(CombinePublisher.self) {
                    saveProfileUseCase
                        .execute(request: ProfileModel())
                        .shouldFinish { isSuccess in
                            expect(isSuccess).to(beTrue())
                        }
                        .before(timeout: 10)
                }
            }
        }
    }
    
}
