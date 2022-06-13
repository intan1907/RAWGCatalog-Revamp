//
//  GetStoresRepository.swift
//  StoreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import Combine
import CoreModule

public struct GetStoresRepository<
    RemoteDataSource: DataSource,
    Transformer: ResponseMapper
>: Repository
where
    RemoteDataSource.Request == Any,
    RemoteDataSource.Response == DAOStoresBaseClass,
    Transformer.Response == DAOStoresBaseClass,
    Transformer.Domain == [StoreModel]
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    public typealias Request = Any // not applicable
    public typealias Response = [StoreModel]
    
    private var remoteDataSource: RemoteDataSource
    private var mapper: Transformer
    
    public init(remoteDataSource: RemoteDataSource, mapper: Transformer) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }
    
    public func execute(request: Any?) -> AnyPublisher<[StoreModel], Error> {
        return self.remoteDataSource.execute(request: request)
            .map { self.mapper.transformResponseToDomain(response: $0) }
            .eraseToAnyPublisher()
    }
}
