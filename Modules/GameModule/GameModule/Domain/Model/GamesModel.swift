//
//  GamesModel.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Foundation

public class GamesModel {
    
    public var totalData: Int? // total data in server
    public var games: [GameModel]?
    
    public init (totalData: Int? = 0, games: [GameModel]? = []) {
        self.totalData = totalData
        self.games = games
    }
    
}
