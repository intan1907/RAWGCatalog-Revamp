//
//  GameSortingPresenter.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 06/06/22.
//

import GameModule

class GameSortingPresenter: BasePresenter {
    
    @Published var sortingOptions: [GameOrderingOption] = []
    @Published var selectedOption: GameOrderingOption?
    
    init(selectedOption: GameOrderingOption?) {
        self.selectedOption = selectedOption
    }
    
    func getSortingOptions() {
        self.sortingOptions = GameOrderingOption.allCases
    }
    
}
