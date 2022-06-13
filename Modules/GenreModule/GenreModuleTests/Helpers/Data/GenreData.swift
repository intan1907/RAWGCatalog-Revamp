//
//  GenreData.swift
//  GenreModuleTests
//
//  Created by Intan Nurjanah on 07/06/22.
//

import CoreModule
import GenreModule

class GenreModuleTestsBundle {
    
    static var bundle: Bundle? {
        let podBundle = Bundle(for: GenreData.self)
        return podBundle
    }
    
}

class GenreData {
    
    static func getGenresDAO() -> DAOGenresBaseClass {
        let data = JSONLoader.load(fileName: "Genres", bundle: GenreModuleTestsBundle.bundle)
        
        guard let genresDAO = try? JSONDecoder().decode(DAOGenresBaseClass.self, from: data) else {
            fatalError("Unable to decode data!")
        }
        
        return genresDAO
    }
    
    static func getGenreDetailDAO() -> DAOGenreDetailBaseClass {
        let data = JSONLoader.load(fileName: "GenreDetail", bundle: GenreModuleTestsBundle.bundle)
        
        guard let genreDetailDAO = try? JSONDecoder().decode(DAOGenreDetailBaseClass.self, from: data) else {
            fatalError("Unable to decode data!")
        }
        
        return genreDetailDAO
    }
    
}
