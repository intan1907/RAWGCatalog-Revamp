//
//  EditProfilePresenter.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/06/22.
//

import Combine
import CoreModule
import AboutModule

class EditProfilePresenter<
    GetProfileInteractor: UseCase,
    SetProfileInteractor: UseCase
>: BasePresenter
where
    GetProfileInteractor.Request == Any,
    GetProfileInteractor.Response == ProfileModel,
    SetProfileInteractor.Request == ProfileModel,
    SetProfileInteractor.Response == Bool
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    private let getProfileUseCase: GetProfileInteractor
    private let saveProfileUseCase: SetProfileInteractor
    
    @Published var profile: ProfileModel?
    @Published var isProfileSaved: Bool = false
    
    init(getProfileUseCase: GetProfileInteractor, saveProfileUseCase: SetProfileInteractor) {
        self.getProfileUseCase = getProfileUseCase
        self.saveProfileUseCase = saveProfileUseCase
    }
    
    func getProfile() {
        self.isLoading = true
        self.getProfileUseCase.execute(request: nil)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.profile = response
            }
            .store(in: &cancellables)
    }
    
    func saveProfile(profile: ProfileModel) {
        self.isLoading = true
        self.saveProfileUseCase.execute(request: profile)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.isProfileSaved = response
            }
            .store(in: &cancellables)
    }
    
}
