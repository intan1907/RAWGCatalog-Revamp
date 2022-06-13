//
//  MockGetAboutAppDataSource.swift
//  AboutModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import Combine
import CoreModule

@testable import AboutModule

struct MockGetAboutAppDataSource: DataSource {
    
    typealias Request = Any
    typealias Response = String
    
    let isDataExist: Bool
    
    init(isDataExist: Bool) {
        self.isDataExist = isDataExist
    }
    
    func execute(request: Any?) -> AnyPublisher<String, Error> {
        return Future<String, Error> { completion in
            if self.isDataExist {
                completion(.success(AboutData.aboutApp))
            } else {
                completion(.success(AboutPrefConstant.aboutAppDefault))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
