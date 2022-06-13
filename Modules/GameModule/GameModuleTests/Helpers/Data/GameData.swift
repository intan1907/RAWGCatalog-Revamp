//
//  GameData.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 07/06/22.
//

import CoreModule
import GameModule

class GameModuleTestsBundle {
    
    static var bundle: Bundle? {
        let podBundle = Bundle(for: GameData.self)
        return podBundle
    }
    
}

class GameData {
    
    static func getGamesDAO() -> DAOGamesBaseClass {
        let data = JSONLoader.load(fileName: "Games", bundle: GameModuleTestsBundle.bundle)
        
        guard let gamesDAO = try? JSONDecoder().decode(DAOGamesBaseClass.self, from: data) else {
            fatalError("Unable to decode data!")
        }
        
        return gamesDAO
    }
    
    static func getGameDetailDAO(id: Int) -> DAOGameDetailBaseClass {
        let data = JSONLoader.load(fileName: "GameDetail_\(id)", bundle: GameModuleTestsBundle.bundle)
        
        guard let gameDetailDAO = try? JSONDecoder().decode(DAOGameDetailBaseClass.self, from: data) else {
            fatalError("Unable to decode data!")
        }
        
        return gameDetailDAO
    }
    
}
