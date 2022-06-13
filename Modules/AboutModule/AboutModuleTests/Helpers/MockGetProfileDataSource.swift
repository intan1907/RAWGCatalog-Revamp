//
//  MockGetProfileDataSource.swift
//  AboutModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Combine
import CoreModule
import AboutModule

struct MockGetProfileDataSource: DataSource {
    
    typealias Request = Any
    typealias Response = ProfileEntity
    
    private let isDataExist: Bool
    
    init(isDataExist: Bool) {
        self.isDataExist = isDataExist
    }
    
    func execute(request: Any?) -> AnyPublisher<ProfileEntity, Error> {
        return Future<ProfileEntity, Error> { completion in
            if self.isDataExist {
                completion(.success(AboutData.dummyProfile))
            } else {
                completion(.success(ProfileEntity.defaultProfile))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
