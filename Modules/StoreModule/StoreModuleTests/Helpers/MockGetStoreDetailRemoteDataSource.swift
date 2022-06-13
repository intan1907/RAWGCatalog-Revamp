//
//  MockGetStoreDetailRemoteDataSource.swift
//  StoreModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import CoreModule
import Combine
import StoreModule

enum MockServiceError: Error {
    case invalidRequest
    case notFound
}

struct MockGetStoreDetailRemoteDataSource: DataSource {
    
    typealias Request = Int
    typealias Response = DAOStoreDetailBaseClass
    
    func execute(request: Int?) -> AnyPublisher<DAOStoreDetailBaseClass, Error> {
        return Future<DAOStoreDetailBaseClass, Error> { completion in
            guard let id = request else {
                completion(.failure(MockServiceError.invalidRequest))
                return
            }
            
            if id == 1 {
                let storeDetail = StoreData.getStoreDetailDAO()
                completion(.success(storeDetail))
            } else {
                completion(.failure(MockServiceError.notFound))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
