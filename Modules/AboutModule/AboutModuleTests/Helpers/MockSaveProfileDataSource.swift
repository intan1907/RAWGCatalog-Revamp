//
//  MockSaveProfileDataSource.swift
//  AboutModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Combine
import CoreModule
import AboutModule

enum MockDatabaseError: Error {
    case invalidRequest
    case notFound
}

struct MockSaveProfileDataSource: DataSource {
    
    typealias Request = ProfileEntity
    typealias Response = Bool
    
    func execute(request: ProfileEntity?) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { completion in
            guard request != nil else {
                completion(.failure(MockDatabaseError.invalidRequest))
                return
            }
            
            completion(.success(true))
        }
        .eraseToAnyPublisher()
    }
    
}
