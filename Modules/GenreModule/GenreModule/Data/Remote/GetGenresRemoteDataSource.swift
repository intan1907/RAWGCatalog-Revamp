//
//  GetGenresRemoteDataSource.swift
//  GenreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import CoreModule
import Combine

public struct GetGenresRemoteDataSource: DataSource {
    
    public typealias Request = Any // not applicable
    public typealias Response = DAOGenresBaseClass
    
    public init() { }
    
    public func execute(request: Any?) -> AnyPublisher<DAOGenresBaseClass, Error> {
        return APIRequest.request(url: GenreAPIService.doGetGenres)
    }
    
}
