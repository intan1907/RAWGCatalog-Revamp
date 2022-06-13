//
//  GetStoresRemoteDataSource.swift
//  StoreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import Combine
import CoreModule

public struct GetStoresRemoteDataSource: DataSource {
    
    public typealias Request = Any // not applicable
    public typealias Response = DAOStoresBaseClass
    
    public init() { }
    
    public func execute(request: Any?) -> AnyPublisher<DAOStoresBaseClass, Error> {
        return APIRequest.request(url: StoreAPIService.doGetStores)
    }
    
}
