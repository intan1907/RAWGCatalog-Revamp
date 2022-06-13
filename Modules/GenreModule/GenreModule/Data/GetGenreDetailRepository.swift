//
//  GetGenreDetailRepository.swift
//  GenreModule
//
//  Created by Intan Nurjanah on 01/06/22.
//

import CoreModule
import Combine

public struct GetGenreDetailRepository<
    RemoteDataSource: DataSource,
    Transformer: ResponseMapper
>: Repository
where
    RemoteDataSource.Request == Int,
    RemoteDataSource.Response == DAOGenreDetailBaseClass,
    Transformer.Response == DAOGenreDetailBaseClass,
    Transformer.Domain == GenreDetailModel
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    public typealias Request = Int
    public typealias Response = GenreDetailModel
    
    private var remoteDataSource: RemoteDataSource
    private var mapper: Transformer
    
    public init(remoteDataSource: RemoteDataSource, mapper: Transformer) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }
    
    public func execute(request: Int?) -> AnyPublisher<GenreDetailModel, Error> {
        return self.remoteDataSource.execute(request: request)
            .map { self.mapper.transformResponseToDomain(response: $0) }
            .eraseToAnyPublisher()
    }
}
