//
//  GetAboutAppRepository.swift
//  AboutModule
//
//  Created by Intan Nurjanah on 10/05/22.
//

import Combine
import CoreModule

public struct GetAboutAppRepository<AboutDataSource: DataSource>: Repository where AboutDataSource.Request == Any, AboutDataSource.Response == String {
    
    public typealias Request = Any // not applicable
    public typealias Response = String
    
    private let dataSource: AboutDataSource
    
    public init(dataSource: AboutDataSource) {
        self.dataSource = dataSource
    }
    
    public func execute(request: Any?) -> AnyPublisher<String, Error> {
        return self.dataSource.execute(request: request)
    }
    
}
