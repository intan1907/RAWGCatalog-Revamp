//
//  MockGetGenresRemoteDataSource.swift
//  GenreModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import CoreModule
import Combine
import GenreModule

struct MockGetGenresRemoteDataSource: DataSource {
    
    typealias Request = Any
    typealias Response = DAOGenresBaseClass
    
    func execute(request: Any?) -> AnyPublisher<DAOGenresBaseClass, Error> {
        return Just(GenreData.getGenresDAO())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
