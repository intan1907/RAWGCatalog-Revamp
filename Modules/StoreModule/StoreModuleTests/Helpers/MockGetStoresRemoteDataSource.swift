//
//  MockGetStoresRemoteDataSource.swift
//  StoreModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Combine
import CoreModule
import StoreModule

struct MockGetStoresRemoteDataSource: DataSource {
    
    typealias Request = Any
    typealias Response = DAOStoresBaseClass
    
    func execute(request: Any?) -> AnyPublisher<DAOStoresBaseClass, Error> {
        let dao = StoreData.getStoresDAO()
        return Just(dao)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
