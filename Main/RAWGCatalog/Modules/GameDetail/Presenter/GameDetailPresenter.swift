//
//  GameDetailPresenter.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/06/22.
//

import Combine
import CoreModule
import GameModule

class GameDetailPresenter<
    GameDetailInteractor: UseCase,
    UpdateGameInteractor: UseCase
>: BasePresenter
where
    GameDetailInteractor.Request == Int,
    GameDetailInteractor.Response == GameDetailModel,
    UpdateGameInteractor.Request == GameDetailModel,
    UpdateGameInteractor.Response == Bool
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    private let gameDetailUseCase: GameDetailInteractor
    private let updateFavoriteGameUseCase: UpdateGameInteractor
    
    @Published var gameDetail: GameDetailModel?
    @Published var isFavorite: Bool = false
    
    private var id: Int
    
    init(gameDetailUseCase: GameDetailInteractor, updateFavoriteGameUseCase: UpdateGameInteractor, id: Int) {
        self.gameDetailUseCase = gameDetailUseCase
        self.updateFavoriteGameUseCase = updateFavoriteGameUseCase
        self.id = id
    }
    
    func getGameDetail() {
        self.isLoading = true
        self.gameDetailUseCase.execute(request: self.id)
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
                self?.gameDetail = response
            }
            .store(in: &cancellables)
    }
    
    func updateGameDetail(model: GameDetailModel) {
        self.isLoading = true
        self.updateFavoriteGameUseCase.execute(request: model)
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
                self?.isFavorite = response
            }
            .store(in: &cancellables)
    }
    
}
