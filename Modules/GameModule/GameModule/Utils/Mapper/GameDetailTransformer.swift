//
//  GameDetailTransformer.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import CoreModule

public struct GameDetailTransformer: ResponseMapper, EntityMapper {
    
    public typealias Response = DAOGameDetailBaseClass
    public typealias Entity = FavoriteGameEntity
    public typealias Domain = GameDetailModel
    
    public init() { }
    
    public func transformResponseToDomain(response: DAOGameDetailBaseClass) -> GameDetailModel {
        let model = GameDetailModel(id: response.id, imageUrl: response.backgroundImage ?? "", name: response.name ?? "-", rating: Double(response.rating ?? 0), playtime: response.playtime ?? 0, metacritic: response.metacritic ?? 0, isFavorite: false)
        // modified date
        let modified = DateHelper.dateParseToString(response.updated ?? "", oldFormat: "yyyy-MM-dd'T'HH:mm:ss", newFormat: "dd MMM yyyy, HH:mm")
        model.lastModified = modified.isEmpty ? "-" : modified
        // get rating category
        let sorted = response.ratings?.sorted(by: { ($0.count ?? 0) > ($1.count ?? 0) })
        let category = sorted?.first?.title?.capitalized ?? ""
        model.ratingCategory = category.isEmpty ? "-" : category
        // about
        let about = response.descriptionRaw ?? "-"
        model.about = about.isEmpty ? "-" : about
        // release
        let release = DateHelper.dateParseToString(response.released ?? "", oldFormat: "yyyy-MM-dd", newFormat: "dd MMM yyyy")
        model.released = release.isEmpty ? "-" : release
        // platform
        let platformNames: [String] = response.parentPlatforms?.map { $0.platform?.name ?? "" } ?? []
        model.platforms = platformNames.isEmpty ? "-" : platformNames.joined(separator: ", ")
        // genre
        let genres: [String] = response.genres?.map { $0.name ?? "" } ?? []
        model.genres = genres.isEmpty ? "-" : genres.joined(separator: ", ")
        // store
        let storeNames: [String] = response.stores?.map { $0.store?.name ?? "" } ?? []
        model.stores = storeNames.isEmpty ? "-" : storeNames.joined(separator: ",")
        
        return model
    }
    
    public func transformDomainToEntity(domain: GameDetailModel) -> FavoriteGameEntity {
        let entity = FavoriteGameEntity()
        entity.id = "\(domain.id ?? 0)"
        entity.image = domain.image
        entity.imageUrl = domain.imageUrl ?? "-"
        entity.name = domain.name ?? "-"
        entity.lastModified = domain.lastModified ?? "-"
        entity.ratingCategory = domain.ratingCategory ?? "-"
        entity.about = domain.about ?? "-"
        entity.released = domain.released ?? "-"
        entity.rating = domain.rating ?? 0
        entity.playtime = domain.playtime ?? 0
        entity.metacritic = domain.metacritic ?? 0
        entity.platforms = domain.platforms ?? "-"
        entity.genres = domain.genres ?? "-"
        entity.stores = domain.stores ?? "-"
        return entity
    }
    
    public func transformEntityToDomain(entity: FavoriteGameEntity) -> GameDetailModel {
        let model = GameDetailModel(id: Int(entity.id), image: entity.image, rating: entity.rating, playtime: entity.playtime, metacritic: entity.metacritic)
        
        let imgUrl = entity.imageUrl
        model.imageUrl = imgUrl.isEmpty ? "-" : imgUrl
        
        let name = entity.name
        model.name = name.isEmpty ? "-" : name
        
        let lastModified = entity.lastModified
        model.lastModified = lastModified.isEmpty ? "-" : lastModified
        
        let ratingCategory = entity.ratingCategory
        model.ratingCategory = ratingCategory.isEmpty ? "-" : ratingCategory
        
        let about = entity.about
        model.about = about.isEmpty ? "-" : about
        
        let released = entity.released
        model.released = released.isEmpty ? "-" : released
        
        let platforms = entity.platforms
        model.platforms = platforms.isEmpty ? "-" : platforms
        
        let genres = entity.genres
        model.genres = genres.isEmpty ? "-" : genres
        
        let stores = entity.stores
        model.stores = stores.isEmpty ? "-" : stores
        
        model.isFavorite = true
        
        return model
    }
    
}
