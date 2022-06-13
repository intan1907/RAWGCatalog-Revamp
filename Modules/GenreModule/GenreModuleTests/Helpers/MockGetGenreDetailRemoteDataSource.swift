//
//  MockGetGenreDetailRemoteDataSource.swift
//  GenreModuleTests
//
//  Created by Intan Nurjanah on 09/06/22.
//

import CoreModule
import Combine
import GenreModule

enum MockServiceError: Error {
    case invalidRequest
    case notFound
}

struct MockGetGenreDetailRemoteDataSource: DataSource {
    
    typealias Request = Int
    typealias Response = DAOGenreDetailBaseClass
    
    func execute(request: Int?) -> AnyPublisher<DAOGenreDetailBaseClass, Error> {
        return Future<DAOGenreDetailBaseClass, Error> { completion in
            guard let id = request else {
                completion(.failure(MockServiceError.invalidRequest))
                return
            }
            
            if id == 1 {
                let genreDAO = GenreData.getGenreDetailDAO()
                completion(.success(genreDAO))
            } else {
                completion(.failure(MockServiceError.notFound))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
