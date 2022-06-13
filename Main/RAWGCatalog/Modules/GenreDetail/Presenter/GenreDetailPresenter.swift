//
//  GenreDetailPresenter.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 05/06/22.
//

import Combine
import CoreModule
import GenreModule
import GameModule

class GenreDetailPresenter<
    GenreInteractor: UseCase,
    GamesInteractor: UseCase
>: BasePresenter
where
    GenreInteractor.Request == Int,
    GenreInteractor.Response == GenreDetailModel,
    GamesInteractor.Request == GameParamModel,
    GamesInteractor.Response == GamesModel
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    private var genreUseCase: GenreInteractor
    private var gamesUseCase: GamesInteractor
    
    @Published var genreDetail: GenreDetailModel?
    @Published var games: GamesModel?
    
    private var genreId: Int
    
    init(genreUseCase: GenreInteractor, gamesUseCase: GamesInteractor, genreId: Int) {
        self.genreUseCase = genreUseCase
        self.gamesUseCase = gamesUseCase
        self.genreId = genreId
    }
    
    func getGenreDetail() {
        self.isLoading = true
        self.genreUseCase.execute(request: self.genreId)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = TextConstant.genresRequest + "_" + error.localizedDescription
                case .finished:
                    // get initial games
                    self.getGames(param: GameParamModel(page: 1, pageSize: 4, genre: self.genreId))
                }
            } receiveValue: { [weak self] response in
                self?.genreDetail = response
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
