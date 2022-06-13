//
//  GetAboutAppUseCaseSpec.swift
//  AboutModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Quick
import Legible
import CoreModule

@testable import AboutModule

class GetAboutAppUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("get about app") {
            context("when data doesn't exist") { [weak self] in
                guard let self = self else { return }
                
                itBehavesLike(CombinePublisher.self) {
                    self.makeAboutAppUseCase(isDataExist: false)
                        .execute(request: nil)
                        .shouldFinish(expectedValue: AboutPrefConstant.aboutAppDefault)
                        .before(timeout: 10)
                }
            }
            
            context("when data is exist") { [weak self] in
                guard let self = self else { return }
                
                itBehavesLike(CombinePublisher.self) {
                    self.makeAboutAppUseCase(isDataExist: true)
                        .execute(request: nil)
                        .shouldFinish(expectedValue: AboutData.aboutApp)
                        .before(timeout: 10)
                }
            }
        }
    }
    
}

// MARK: GetAboutAppUseCaseSpec Helper
extension GetAboutAppUseCaseSpec {
    
    func makeAboutAppUseCase(isDataExist: Bool)
    -> Interactor<
        Any,
        String,
        GetAboutAppRepository<MockGetAboutAppDataSource>
    >! {
        let dataSource = MockGetAboutAppDataSource(isDataExist: isDataExist)
        let repository = GetAboutAppRepository(dataSource: dataSource)
        
        return Interactor(repository: repository)
    }
    
}
