//
//  StoreData.swift
//  StoreModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import CoreModule
import StoreModule

class StoreModuleTestsBundle {
    
    static var bundle: Bundle? {
        let podBundle = Bundle(for: StoreData.self)
        return podBundle
    }
    
}

class StoreData {
    
    static func getStoresDAO() -> DAOStoresBaseClass {
        let data = JSONLoader.load(fileName: "Stores", bundle: StoreModuleTestsBundle.bundle)
        
        guard let storesDAO = try? JSONDecoder().decode(DAOStoresBaseClass.self, from: data) else {
            fatalError("Unable to decode data!")
        }
        
        return storesDAO
    }
    
    static func getStoreDetailDAO() -> DAOStoreDetailBaseClass {
        let data = JSONLoader.load(fileName: "StoreDetail", bundle: StoreModuleTestsBundle.bundle)
        
        guard let storeDetailDAO = try? JSONDecoder().decode(DAOStoreDetailBaseClass.self, from: data) else {
            fatalError("Unable to decode data!")
        }
        
        return storeDetailDAO
    }
    
}
