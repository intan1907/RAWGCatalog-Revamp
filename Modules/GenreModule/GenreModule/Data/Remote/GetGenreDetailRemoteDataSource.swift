//
//  GetGenreDetailRemoteDataSource.swift
//  GenreModule
//
//  Created by Intan Nurjanah on 01/06/22.
//

import CoreModule
import Combine

public struct GetGenreDetailRemoteDataSource: DataSource {
    
    public typealias Request = Int
    public typealias Response = DAOGenreDetailBaseClass
    
    public init() { }
    
    public func execute(request: Int?) -> AnyPublisher<DAOGenreDetailBaseClass, Error> {
        guard let id = request else {
            return Fail(error: CustomHttpError.noRequest)
                .eraseToAnyPublisher()
        }
        return APIRequest.request(url: GenreAPIService.doGetGenreDetail(id: id))
    }
    
}
