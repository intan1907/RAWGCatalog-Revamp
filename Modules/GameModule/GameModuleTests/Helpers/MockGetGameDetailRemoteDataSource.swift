//
//  MockGetGameDetailRemoteDataSource.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 07/06/22.
//

import CoreModule
import GameModule
import Combine

struct MockGetGameDetailRemoteDataSource: DataSource {
    
    typealias Request = Int
    typealias Response = DAOGameDetailBaseClass
    
    func execute(request: Int?) -> AnyPublisher<DAOGameDetailBaseClass, Error> {
        return Future<DAOGameDetailBaseClass, Error> { completion in
            guard let id = request else {
                completion(.failure(MockServiceError.invalidRequest))
                return
            }
            
            if id == 3498 {
                let dao = GameData.getGameDetailDAO(id: 3498)
                completion(.success(dao))
            } else if id == 5286 {
                let dao = GameData.getGameDetailDAO(id: 5286)
                completion(.success(dao))
            } else {
                completion(.failure(MockServiceError.notFound))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
