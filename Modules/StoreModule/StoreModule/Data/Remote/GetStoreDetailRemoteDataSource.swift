//
//  GetStoreDetailRemoteDataSource.swift
//  StoreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import Combine
import CoreModule

public struct GetStoreDetailRemoteDataSource: DataSource {
    
    public typealias Request = Int
    public typealias Response = DAOStoreDetailBaseClass
    
    public init() { }
    
    public func execute(request: Int?) -> AnyPublisher<DAOStoreDetailBaseClass, Error> {
        guard let storeId = request else {
            return Fail(error: CustomHttpError.noRequest)
                .eraseToAnyPublisher()
        }
        return APIRequest.request(url: StoreAPIService.doGetStoreDetail(id: storeId))
    }
    
}
