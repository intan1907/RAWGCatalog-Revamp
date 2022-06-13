//
//  GamesPresenter.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 06/06/22.
//

import Combine
import CoreModule
import GameModule

class GamesPresenter<Interactor: UseCase>: BasePresenter
where Interactor.Request == GameParamModel, Interactor.Response == GamesModel {
    
    private let useCase: Interactor
    
    @Published public var games: GamesModel?
    @Published public var genreName: String = ""
    @Published public var storeName: String = ""
    
    private var param: GameParamModel
    
    init(useCase: Interactor, param: GameParamModel?) {
        self.useCase = useCase
        
        self.param = GameParamModel(page: 1, pageSize: 10)
        if let givenParam = param {
            self.param.genre = givenParam.genre
            self.param.store = givenParam.store
            
            self.genreName = givenParam.genreName ?? ""
            self.storeName = givenParam.storeName ?? ""
        }
    }
    
    func execute(page: Int, search: String?, ordering: GameOrderingOption?) {
        self.isLoading = true
        self.param.page = page
        self.param.search = search
        self.param.ordering = ordering
        self.useCase.execute(request: self.param)
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
                self?.games = response
            }
            .store(in: &cancellables)
    }
    
}
