//
//  AboutPresenter.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/06/22.
//

import Combine
import CoreModule
import AboutModule

class AboutPresenter<
    ProfileInteractor: UseCase,
    AboutAppInteractor: UseCase
>: BasePresenter
where
    ProfileInteractor.Request == Any,
    ProfileInteractor.Response == ProfileModel,
    AboutAppInteractor.Request == Any,
    AboutAppInteractor.Response == String
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    private let profileUseCase: ProfileInteractor
    private let aboutAppUseCase: AboutAppInteractor
    
    @Published var profile: ProfileModel?
    @Published var aboutApp: String = ""
    
    init(
        profileUseCase: ProfileInteractor,
        aboutAppUseCase: AboutAppInteractor
    ) {
        self.profileUseCase = profileUseCase
        self.aboutAppUseCase = aboutAppUseCase
    }
    
    func getProfile() {
        self.isLoading = true
        self.profileUseCase.execute(request: nil)
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
    
    func getAboutApp() {
        self.aboutAppUseCase.execute(request: nil)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.aboutApp = response
            }
            .store(in: &cancellables)
    }
}
