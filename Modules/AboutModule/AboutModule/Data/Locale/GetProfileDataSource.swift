//
//  GetProfileDataSource.swift
//  AboutModule
//
//  Created by Intan Nurjanah on 10/05/22.
//

import Combine
import CoreModule

public struct GetProfileDataSource: DataSource {
    
    public typealias Request = Any // not applicable
    public typealias Response = ProfileEntity
    
    public init () { }
    
    public func execute(request: Any?) -> AnyPublisher<ProfileEntity, Error> {
        do {
            let profile = try PrefHelper.getObject(key: AboutPrefConstant.keyProfile, castTo: ProfileEntity.self)
            return Just(profile)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            if error.localizedDescription == ObjectSavableError.noValue.rawValue {
                return self.getDefaultProfile()
            } else {
                return Fail<ProfileEntity, Error>(error: error)
                    .eraseToAnyPublisher()
            }
        }
    }
    
    private func getDefaultProfile() -> AnyPublisher<ProfileEntity, Error> {
        return Future<ProfileEntity, Error> { completion in
            do {
                let profile = ProfileEntity.defaultProfile
                try PrefHelper.saveObject(key: AboutPrefConstant.keyProfile, value: profile)
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
