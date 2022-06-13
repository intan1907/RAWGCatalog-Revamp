//
//  SaveProfileRepository.swift
//  AboutModule
//
//  Created by Intan Nurjanah on 10/05/22.
//

import Combine
import CoreModule

public struct SaveProfileRepository<
    ProfileDataSource: DataSource,
    Transformer: EntityMapper
>: Repository
where
    ProfileDataSource.Request == ProfileEntity,
    ProfileDataSource.Response == Bool,
    Transformer.Entity == ProfileEntity,
    Transformer.Domain == ProfileModel
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    public typealias Request = ProfileModel
    public typealias Response = Bool
    
    private let dataSource: ProfileDataSource
    private let mapper: Transformer
    
    public init(dataSource: ProfileDataSource, mapper: Transformer) {
        self.dataSource = dataSource
        self.mapper = mapper
    }
    
    public func execute(request: ProfileModel?) -> AnyPublisher<Bool, Error> {
        guard let request = request else {
            fatalError("Request could not be empty")
        }
        
        let entity = self.mapper.transformDomainToEntity(domain: request)
        return self.dataSource.execute(request: entity)
    }
}
