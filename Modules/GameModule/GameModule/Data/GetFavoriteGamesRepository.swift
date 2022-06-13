//
//  GetFavoriteGamesRepository.swift
//  GameModule
//
//  Created by Intan Nurjanah on 22/04/22.
//

import Combine
import CoreModule

public struct GetFavoriteGamesRepository<
    LocalDataSource: LocaleDataSource,
    Transformer: ResponseMapper & EntityMapper
>: Repository
where
    LocalDataSource.Request == Any,
    LocalDataSource.Response == FavoriteGameEntity,
    Transformer.Response == DAOGameDetailBaseClass,
    Transformer.Domain == GameDetailModel,
    Transformer.Entity == FavoriteGameEntity
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    public typealias Request = Any // not applicable
    public typealias Response = [GameDetailModel]
    
    private var localeDataSource: LocalDataSource
    private var mapper: Transformer
    
    public init (localeDataSource: LocalDataSource, mapper: Transformer) {
        self.localeDataSource = localeDataSource
        self.mapper = mapper
    }
        
    public func execute(request: Any?) -> AnyPublisher<[GameDetailModel], Error> {
        return self.localeDataSource.list(request: request)
            .map { entities in
                return entities.map {
                    self.mapper.transformEntityToDomain(entity: $0)
                }
            }
            .eraseToAnyPublisher()
    }
}
