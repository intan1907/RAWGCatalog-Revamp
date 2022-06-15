//
//  GetGameDetailRepository.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Combine
import CoreModule

public struct GetGameDetailRepository<
    LocalDataSource: LocaleDataSource,
    RemoteDataSource: DataSource,
    Transformer: ResponseMapper & EntityMapper
>: Repository
where
    LocalDataSource.Request == Any,
    LocalDataSource.Response == FavoriteGameEntity,
    RemoteDataSource.Request == Int,
    RemoteDataSource.Response == DAOGameDetailBaseClass,
    Transformer.Response == DAOGameDetailBaseClass,
    Transformer.Domain == GameDetailModel,
    Transformer.Entity == FavoriteGameEntity
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    public typealias Request = Int
    public typealias Response = GameDetailModel
    
    private let localeDataSource: LocalDataSource
    private let remoteDataSource: RemoteDataSource
    private let mapper: Transformer
    private var gameDetail: GameDetailModel?
    
    public init(
        localeDataSource: LocalDataSource,
        remoteDataSource: RemoteDataSource,
        mapper: Transformer,
        gameDetail: GameDetailModel? = nil
    ) {
        self.localeDataSource = localeDataSource
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
        self.gameDetail = gameDetail
    }
    
    public func execute(request: Int?) -> AnyPublisher<GameDetailModel, Error> {
        guard let id = request else {
            return Fail(error: CustomHttpError.noRequest)
                .eraseToAnyPublisher()
        }
        
        if let detail = self.gameDetail, detail.id == id {
            detail.isFavorite = true // infer that this model is favoeite
            return Just(detail)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            // first, check if data (the game detail) exist in locale data source
            return self.localeDataSource.get(id: "\(id)")
                // if locale data exist, automatically fetch data from remote data source,
                // then re-save it to locale data source
                // so that the locale data is always up-to-date
                .flatMap { entity in
                    self.remoteDataSource.execute(request: id)
                        .map { self.mapper.transformResponseToDomain(response: $0) }
                        .map { self.mapper.transformDomainToEntity(domain: $0) }
                        .flatMap { updatedEntity in
                            self.localeDataSource.add(entities: [updatedEntity])
                        }
                        .flatMap { _ in
                            self.localeDataSource.get(id: "\(id)")
                                .map { self.mapper.transformEntityToDomain(entity: $0) }
                        }
                        // if remote data source return error, then return (old) locale data
                        .catch { _ -> AnyPublisher<GameDetailModel, Error> in
                            let gameDetail = self.mapper.transformEntityToDomain(entity: entity)
                            return Just(gameDetail)
                                .setFailureType(to: Error.self)
                                .eraseToAnyPublisher()
                        }
                }
                // if locale data source return error or locale game detail doesn't exist,
                // then fetch data from remote data source
                .catch { _ in
                    return self.remoteDataSource.execute(request: id)
                        .map { self.mapper.transformResponseToDomain(response: $0) }
                }
                .eraseToAnyPublisher()
        }
    }
}
