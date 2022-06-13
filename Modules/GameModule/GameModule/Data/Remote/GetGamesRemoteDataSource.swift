//
//  GetGamesRemoteDataSource.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Combine
import CoreModule
import Alamofire

public struct GetGamesRemoteDataSource: DataSource {
    
    public typealias Request = [String: Any]
    public typealias Response = DAOGamesBaseClass
    
    public init() { }
    
    public func execute(request: [String: Any]?) -> AnyPublisher<DAOGamesBaseClass, Error> {
        guard let request = request else {
            return Fail(error: CustomHttpError.noRequest)
                .eraseToAnyPublisher()
        }
        return APIRequest.request(url: GameAPIService.doGetGames(param: request))
    }
}
