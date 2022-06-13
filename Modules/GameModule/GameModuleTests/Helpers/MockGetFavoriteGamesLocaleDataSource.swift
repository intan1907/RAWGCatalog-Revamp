//
//  MockGetFavoriteGamesLocaleDataSource.swift
//  GameModuleTests
//
//  Created by Intan Nurjanah on 07/06/22.
//

import CoreModule
import GameModule
import Combine

enum MockDatabaseError: Error {
    case invalidRequest
    case notFound
}

struct MockGetFavoriteGamesLocaleDataSource: LocaleDataSource {
    
    typealias Request = Any
    typealias Response = FavoriteGameEntity
    
    private let mapper: GameDetailTransformer
    private let isDataEmpty: Bool
    
    init(isDataEmpty: Bool = false) {
        self.mapper = GameDetailTransformer()
        self.isDataEmpty = isDataEmpty
    }
    
    func list(request: Any?) -> AnyPublisher<[FavoriteGameEntity], Error> {
        return Future<[FavoriteGameEntity], Error> { completion in
            if self.isDataEmpty {
                completion(.success([]))
                return
            }
            
            let dao = GameData.getGameDetailDAO(id: 3498)
            let model = mapper.transformResponseToDomain(response: dao)
            model.isFavorite = true
            let entity = mapper.transformDomainToEntity(domain: model)
            
            let model2 = GameDetailModel(id: 2000, isFavorite: true)
            let entity2 = mapper.transformDomainToEntity(domain: model2)
            
            completion(.success([entity, entity2]))
        }
        .eraseToAnyPublisher()
    }
    
    func add(entities: [FavoriteGameEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if entities.isEmpty {
                completion(.failure(MockDatabaseError.invalidRequest))
            } else {
                completion(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func get(id: String) -> AnyPublisher<FavoriteGameEntity, Error> {
        return Future<FavoriteGameEntity, Error> { completion in
            if id == "3498" {
                let dao = GameData.getGameDetailDAO(id: 3498)
                let model = mapper.transformResponseToDomain(response: dao)
                model.isFavorite = true
                let entity = mapper.transformDomainToEntity(domain: model)
                completion(.success(entity))
            } else if id == "2000" {
                let model = GameDetailModel(id: 2000)
                let entity = mapper.transformDomainToEntity(domain: model)
                completion(.success(entity))
            } else {
                completion(.failure(MockDatabaseError.notFound))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(id: String, entity: FavoriteGameEntity) -> AnyPublisher<Bool, Error> {
        fatalError()
    }
    
    func delete(id: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if id == "3498" || id == "2000" {
                completion(.success(true))
            } else {
                completion(.failure(MockDatabaseError.notFound))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
