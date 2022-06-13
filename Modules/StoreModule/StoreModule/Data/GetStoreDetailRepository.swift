//
//  GetStoreDetailRepository.swift
//  StoreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import Combine
import CoreModule

public struct GetStoreDetailRepository<
    RemoteDataSource: DataSource,
    Transformer: ResponseMapper
>: Repository
where
    RemoteDataSource.Request == Int,
    RemoteDataSource.Response == DAOStoreDetailBaseClass,
    Transformer.Response == DAOStoreDetailBaseClass,
    Transformer.Domain == StoreDetailModel
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    public typealias Request = Int
    public typealias Response = StoreDetailModel
    
    private var remoteDataSource: RemoteDataSource
    private var mapper: Transformer
    
    public init(remoteDataSource: RemoteDataSource, mapper: Transformer) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }
    
    public func execute(request: Int?) -> AnyPublisher<StoreDetailModel, Error> {
        return self.remoteDataSource.execute(request: request)
            .map { self.mapper.transformResponseToDomain(response: $0) }
            .eraseToAnyPublisher()
    }
}
