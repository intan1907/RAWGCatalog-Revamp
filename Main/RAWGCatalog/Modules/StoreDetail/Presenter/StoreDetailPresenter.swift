//
//  StoreDetailPresenter.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 06/06/22.
//

import Combine
import CoreModule
import StoreModule
import GameModule

class StoreDetailPresenter<
    StoreInteractor: UseCase,
    GamesInteractor: UseCase
>: BasePresenter
where
    StoreInteractor.Request == Int,
    StoreInteractor.Response == StoreDetailModel,
    GamesInteractor.Request == GameParamModel,
    GamesInteractor.Response == GamesModel
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    private var storeUseCase: StoreInteractor
    private var gamesUseCase: GamesInteractor
    
    @Published var storeDetail: StoreDetailModel?
    @Published var games: GamesModel?
    
    private var storeId: Int
    
    init(storeUseCase: StoreInteractor, gamesUseCase: GamesInteractor, storeId: Int) {
        self.storeUseCase = storeUseCase
        self.gamesUseCase = gamesUseCase
        self.storeId = storeId
    }
    
    func getStoreDetail() {
        self.isLoading = true
        self.storeUseCase.execute(request: self.storeId)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = TextConstant.genresRequest + "_" + error.localizedDescription
                case .finished:
                    // get initial games
                    self.getGames(param: GameParamModel(page: 1, pageSize: 4, store: self.storeId))
                }
            } receiveValue: { [weak self] response in
                self?.storeDetail = response
            }
            .store(in: &cancellables)
    }
    
    func getGames(param: GameParamModel) {
        self.isLoading = true
        self.gamesUseCase.execute(request: param)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = TextConstant.gamesRequest + "_" + error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.games = response
            }
            .store(in: &cancellables)
    }
    
}
