//
//  UpdateFavoriteGameRepository.swift
//  GameModule
//
//  Created by Intan Nurjanah on 09/05/22.
//

import Combine
import CoreModule

// for handling update isFavorite status
public struct UpdateFavoriteGameRepository<
    LocalDataSource: LocaleDataSource,
    Transformer: EntityMapper
>: Repository
where
    LocalDataSource.Request == Any,
    LocalDataSource.Response == FavoriteGameEntity,
    Transformer.Entity == FavoriteGameEntity,
    Transformer.Domain == GameDetailModel
// Why disable next opening brace? in the Swift Style Guide, opening brace optionally appear on the next line.
// See https://google.github.io/swift/#type-and-extension-declarations
// swiftlint:disable:next opening_brace
{
    public typealias Request = GameDetailModel
    public typealias Response = Bool
    
    private var localeDataSource: LocalDataSource
    private var mapper: Transformer
    
    public init(localeDataSource: LocalDataSource, mapper: Transformer) {
        self.localeDataSource = localeDataSource
        self.mapper = mapper
    }
    
    // suppose to return isFavorite status
    public func execute(request: GameDetailModel?) -> AnyPublisher<Bool, Error> {
        guard let unsavedModel = request, let id = request?.id else {
            fatalError("Request could not be empty")
        }
        
        let strId = "\(id)"
        if unsavedModel.isFavorite ?? false {
            let unsavedEntity = self.mapper.transformDomainToEntity(domain: unsavedModel)
            // try to update isFavorite to true by add game to data base
            // if success, it will return true. The result can be directly assigned to isFavorite
            return self.localeDataSource.add(entities: [unsavedEntity])
        } else {
            // try to update isFavorite to false by delete game from data base
            // if success, it will return true
            return self.localeDataSource.delete(id: strId)
                .map { !$0 } // toggle the result to return isFavorite = false
                .eraseToAnyPublisher()
        }
    }
}
