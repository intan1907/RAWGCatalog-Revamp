//
//  HomePresenter.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 30/05/22.
//

import Combine
import CoreModule
import GameModule
import GenreModule
import StoreModule

class HomePresenter<
    GameInteractor: UseCase,
    GenreInteractor: UseCase,
    StoreInteractor: UseCase
>: BasePresenter
where
    GameInteractor.Request == GameParamModel,
    GameInteractor.Response == GamesModel,
    GenreInteractor.Request == Any,
    GenreInteractor.Response == [GenreModel],
    StoreInteractor.Request == Any,
    StoreInteractor.Response == [StoreModel]
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    private var gameUseCase: GameInteractor
    private var genreUseCase: GenreInteractor
    private var storeUseCase: StoreInteractor
    
    @Published var featuredGames: [GameModel]?
    @Published var genres: [GenreModel]?
    @Published var games: [GameModel]?
    @Published var stores: [StoreModel]?
    
    init(
        gameUseCase: GameInteractor,
        genreUseCase: GenreInteractor,
        storeUseCase: StoreInteractor
    ) {
        self.gameUseCase = gameUseCase
        self.genreUseCase = genreUseCase
        self.storeUseCase = storeUseCase
    }
    
    func getFeaturedGames() {
        let param = GameParamModel(page: 1, pageSize: 5, genreName: "platformer")
        self.gameUseCase.execute(request: param)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = TextConstant.featuredGamesRequest + "_" + error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.featuredGames = response.games ?? []
            }
            .store(in: &cancellables)
    }
    
    func getGenres() {
        self.isLoading = true
        self.genreUseCase.execute(request: nil)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = TextConstant.genresRequest + "_" + error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.genres = response
            }
            .store(in: &cancellables)
    }
    
    func getGames() {
        let param = GameParamModel(page: 1, pageSize: 8)
        self.gameUseCase.execute(request: param)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = TextConstant.gamesRequest + "_" + error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.games = response.games ?? []
            }
            .store(in: &cancellables)
    }
    
    func getStores() {
        self.storeUseCase.execute(request: nil)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = TextConstant.storesRequest + "_" + error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.stores = response
            }
            .store(in: &cancellables)
    }
    
}
