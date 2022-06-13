//
//  GetFavoriteGamesLocaleDataSource.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Combine
import RealmSwift
import CoreModule

public struct GetFavoriteGamesLocaleDataSource: LocaleDataSource {
    
    public typealias Request = Any
    public typealias Response = FavoriteGameEntity
    
    private let realm: Realm?
    
    public init(realm: Realm?) {
        self.realm = realm
    }
    
    public func list(request: Any?) -> AnyPublisher<[FavoriteGameEntity], Error> {
        return Future<[FavoriteGameEntity], Error> { completion in
            guard let realm = self.realm else {
                completion(.failure(DatabaseError.invalidInstance))
                return
            }
            
            let favorites: Results<FavoriteGameEntity> = {
                realm.objects(FavoriteGameEntity.self)
                    .sorted(byKeyPath: "createdDate", ascending: false)
            }()
            completion(.success(favorites.toArray(ofType: FavoriteGameEntity.self)))
        }
        .eraseToAnyPublisher()
    }
    
    public func add(entities: [FavoriteGameEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            guard let realm = self.realm else {
                completion(.failure(DatabaseError.invalidInstance))
                return
            }
            
            do {
                try realm.write {
                    entities.forEach { entity in
                        realm.add(entity, update: .modified)
                    }
                }
                completion(.success(true))
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func get(id: String) -> AnyPublisher<FavoriteGameEntity, Error> {
        return Future<FavoriteGameEntity, Error> { completion in
            guard let realm = self.realm else {
                completion(.failure(DatabaseError.invalidInstance))
                return
            }
            
            let obj = realm.object(ofType: FavoriteGameEntity.self, forPrimaryKey: id)
            guard let entity = obj else {
                completion(.failure(DatabaseError.requestFailed))
                return
            }
            
            completion(.success(entity))
        }
        .eraseToAnyPublisher()
    }
    
    public func update(id: String, entity: FavoriteGameEntity) -> AnyPublisher<Bool, Error> {
        fatalError()
    }
    
    public func delete(id: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            guard let realm = self.realm else {
                completion(.failure(DatabaseError.invalidInstance))
                return
            }
            
            do {
                try realm.write {
                    if let game = realm.object(ofType: FavoriteGameEntity.self, forPrimaryKey: id) {
                        realm.delete(game)
                        completion(.success(true))
                    } else {
                        completion(.failure(DatabaseError.requestFailed))
                    }
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
