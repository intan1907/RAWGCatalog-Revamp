//
//  GetGameDetailRemoteDataSource.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Combine
import CoreModule

public struct GetGameDetailRemoteDataSource: DataSource {
    
    public typealias Request = Int
    public typealias Response = DAOGameDetailBaseClass
    
    public init() { }
    
    public func execute(request: Int?) -> AnyPublisher<DAOGameDetailBaseClass, Error> {
        guard let id = request else {
            return Fail<DAOGameDetailBaseClass, Error>(error: CustomHttpError.noRequest)
                .eraseToAnyPublisher()
        }
        
        return APIRequest.request(url: GameAPIService.doGetGameDetail(id: id))
    }
    
}
