//
//  GetGenresRepository.swift
//  GenreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import CoreModule
import Combine

public struct GetGenresRepository<
    RemoteDataSource: DataSource,
    Transformer: ResponseMapper
>: Repository
where
    RemoteDataSource.Request == Any,
    RemoteDataSource.Response == DAOGenresBaseClass,
    Transformer.Response == DAOGenresBaseClass,
    Transformer.Domain == [GenreModel]
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    public typealias Request = Any // not applicable
    public typealias Response = [GenreModel]
    
    private var remoteDataSource: RemoteDataSource
    private var mapper: Transformer
    
    public init(remoteDataSource: RemoteDataSource, mapper: Transformer) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }
        
    public func execute(request: Any?) -> AnyPublisher<[GenreModel], Error> {
        return self.remoteDataSource.execute(request: request)
            .map { self.mapper.transformResponseToDomain(response: $0) }
            .eraseToAnyPublisher()
    }
}
