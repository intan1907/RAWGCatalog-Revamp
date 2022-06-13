//
//  GetAboutAppDataSource.swift
//  AboutModule
//
//  Created by Intan Nurjanah on 10/05/22.
//

import Combine
import CoreModule

public struct GetAboutAppDataSource: DataSource {
    
    public typealias Request = Any
    public typealias Response = String
    
    public init() { }
    
    public func execute(request: Any?) -> AnyPublisher<String, Error> {
        let aboutApp = PrefHelper.getString(key: AboutPrefConstant.keyAboutApp)
        if aboutApp.isEmpty {
            let aboutDesc = AboutPrefConstant.aboutAppDefault
            PrefHelper.saveString(key: AboutPrefConstant.keyAboutApp, value: aboutDesc)
            return Just(aboutDesc)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Just(aboutApp)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
