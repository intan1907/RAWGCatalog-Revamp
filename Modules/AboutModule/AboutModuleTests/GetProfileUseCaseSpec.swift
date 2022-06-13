//
//  GetProfileUseCaseSpec.swift
//  AboutModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Quick
import Nimble
import Legible
import CoreModule

@testable import AboutModule

class GetProfileUseCaseSpec: QuickSpec {
    
    override func spec() {
        describe("get profile") {
            context("when there is no saved profile") { [weak self] in
                guard let self = self else { return }
                
                itBehavesLike(CombinePublisher.self) {
                    self.makeProfileUseCase(isDataExist: false)
                        .execute(request: nil)
                        .shouldFinish { profile in
                            expect(profile.profilePicture).to(beNil())
                            
                            let defaultProfile = ProfileEntity.defaultProfile
                            self.verifyProfile(profile, expected: defaultProfile)
                        }
                        .before(timeout: 10)
                }
            }
            
            context("when data exist on the data source") { [weak self] in
                guard let self = self else { return }
                
                itBehavesLike(CombinePublisher.self) {
                    self.makeProfileUseCase(isDataExist: true)
                        .execute(request: nil)
                        .shouldFinish { profile in
                            expect(profile.profilePicture).to(beNil())
                            
                            let dummyProfile = AboutData.dummyProfile
                            self.verifyProfile(profile, expected: dummyProfile)
                        }
                        .before(timeout: 10)
                }
            }
            
            context("when data that passed to the repository") { [weak self] in
                guard let self = self else { return }

                let passedProfile = ProfileModel(
                    profilePicture: nil,
                    fullName: "passed fullname",
                    username: "passed username",
                    email: "passed email",
                    about: "passed about"
                )

                itBehavesLike(CombinePublisher.self) {
                    self.makeProfileUseCase(profile: passedProfile)
                        .execute(request: nil)
                        .shouldFinish { profile in
                            expect(profile.profilePicture).to(beNil())
                            self.verifyProfile(profile, expected: passedProfile)
                        }
                        .before(timeout: 10)
                }
            }
        }
    }
    
}

// MARK: GetProfileUseCaseSpec Helper
extension GetProfileUseCaseSpec {
    
    func makeProfileUseCase(
        isDataExist: Bool? = nil,
        profile: ProfileModel? = nil
    ) -> Interactor<
        Any,
        ProfileModel,
        GetProfileRepository<
            MockGetProfileDataSource,
            ProfileTransformer
        >
    >! {
        let dataSource = MockGetProfileDataSource(isDataExist: isDataExist ?? false)
        let transformer = ProfileTransformer()
        
        let repository = GetProfileRepository(dataSource: dataSource, mapper: transformer, profile: profile)
        return Interactor(repository: repository)
    }
    
    func verifyProfile(_ profile: ProfileModel, expected: ProfileEntity) {
        expect(profile.fullName).to(equal(expected.fullName))
        expect(profile.username).to(equal(expected.username))
        expect(profile.email).to(equal(expected.email))
        expect(profile.about).to(equal(expected.about))
    }
    
    func verifyProfile(_ profile: ProfileModel, expected: ProfileModel) {
        expect(profile.fullName).to(equal(expected.fullName))
        expect(profile.username).to(equal(expected.username))
        expect(profile.email).to(equal(expected.email))
        expect(profile.about).to(equal(expected.about))
    }
    
}
