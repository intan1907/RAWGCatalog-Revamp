//
//  MockGetGamesRemoteDataSource.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 07/06/22.
//

import CoreModule
import GameModule
import Combine

enum MockServiceError: Error {
    case invalidRequest
    case notFound
}

struct MockGetGamesRemoteDataSource: DataSource {
    
    typealias Request = [String: Any]
    typealias Response = DAOGamesBaseClass
    
    func execute(request: [String: Any]?) -> AnyPublisher<DAOGamesBaseClass, Error> {
        return Future<DAOGamesBaseClass, Error> { completion in
            guard let page = request?["page"] as? Int, page > 0 else {
                completion(.failure(MockServiceError.invalidRequest))
                return
            }
            let dao = GameData.getGamesDAO()
            completion(.success(dao))
        }
        .eraseToAnyPublisher()
    }
    
}
