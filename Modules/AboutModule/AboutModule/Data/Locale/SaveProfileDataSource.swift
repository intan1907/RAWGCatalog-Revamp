//
//  SaveProfileDataSource.swift
//  AboutModule
//
//  Created by Intan Nurjanah on 10/05/22.
//

import Combine
import CoreModule

public struct SaveProfileDataSource: DataSource {
    
    public typealias Request = ProfileEntity
    public typealias Response = Bool
    
    public init() { }
    
    public func execute(request: ProfileEntity?) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            guard let profile = request else {
                completion(.failure(DatabaseError.requestFailed))
                return
            }
            
            do {
                try PrefHelper.saveObject(key: AboutPrefConstant.keyProfile, value: profile)
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
