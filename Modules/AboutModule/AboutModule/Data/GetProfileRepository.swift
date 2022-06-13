//
//  GetProfileRepository.swift
//  AboutModule
//
//  Created by Intan Nurjanah on 10/05/22.
//

import Combine
import CoreModule

public struct GetProfileRepository<
    ProfileDataSource: DataSource,
    Transformer: EntityMapper
>: Repository
where
    ProfileDataSource.Request == Any,
    ProfileDataSource.Response == ProfileEntity,
    Transformer.Entity == ProfileEntity,
    Transformer.Domain == ProfileModel
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    public typealias Request = Any // not applicable
    public typealias Response = ProfileModel
    
    private let dataSource: ProfileDataSource
    private let mapper: Transformer
    private let profile: ProfileModel?
        
    public init(dataSource: ProfileDataSource, mapper: Transformer, profile: ProfileModel?) {
        self.dataSource = dataSource
        self.mapper = mapper
        self.profile = profile
    }
    
    public func execute(request: Any?) -> AnyPublisher<ProfileModel, Error> {
        if let profile = self.profile {
            return Just(profile)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return self.dataSource.execute(request: request)
                .map { self.mapper.transformEntityToDomain(entity: $0) }
                .eraseToAnyPublisher()
        }
    }
}
