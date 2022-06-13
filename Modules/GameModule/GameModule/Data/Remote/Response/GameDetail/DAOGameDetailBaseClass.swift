//
//  DAOGameDetailBaseClass.swift
//
//  Created by Intan Nurjanah on 13/09/21
//  Copyright (c) intan3951. All rights reserved.
//

import Foundation

public class DAOGameDetailBaseClass: Codable {
    
    enum CodingKeys: String, CodingKey {
        case backgroundImage = "background_image"
        case ratings
        case rating
        case genres
        case website
        case parentPlatforms = "parent_platforms"
        case metacritic
        case descriptionRaw = "description_raw"
        case stores
        case id
        case updated
        case name
        case released
        case playtime
    }
    
    var backgroundImage: String?
    var ratings: [DAOGameDetailRatings]?
    var rating: Float?
    var genres: [DAOGameDetailGenres]?
    var website: String?
    var parentPlatforms: [DAOGameDetailParentPlatforms]?
    var metacritic: Int?
    var descriptionRaw: String?
    var stores: [DAOGameDetailStores]?
    var id: Int?
    var updated: String?
    var name: String?
    var released: String?
    var playtime: Int?
    
    public init (backgroundImage: String?, ratings: [DAOGameDetailRatings]?, rating: Float?, genres: [DAOGameDetailGenres]?, website: String?, parentPlatforms: [DAOGameDetailParentPlatforms]?, metacritic: Int?, descriptionRaw: String?, stores: [DAOGameDetailStores]?, id: Int?, updated: String?, name: String?, released: String?, playtime: Int?) {
        self.backgroundImage = backgroundImage
        self.ratings = ratings
        self.rating = rating
        self.genres = genres
        self.website = website
        self.parentPlatforms = parentPlatforms
        self.metacritic = metacritic
        self.descriptionRaw = descriptionRaw
        self.stores = stores
        self.id = id
        self.updated = updated
        self.name = name
        self.released = released
        self.playtime = playtime
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        backgroundImage = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
        ratings = try container.decodeIfPresent([DAOGameDetailRatings].self, forKey: .ratings)
        rating = try container.decodeIfPresent(Float.self, forKey: .rating)
        genres = try container.decodeIfPresent([DAOGameDetailGenres].self, forKey: .genres)
        website = try container.decodeIfPresent(String.self, forKey: .website)
        parentPlatforms = try container.decodeIfPresent([DAOGameDetailParentPlatforms].self, forKey: .parentPlatforms)
        metacritic = try container.decodeIfPresent(Int.self, forKey: .metacritic)
        descriptionRaw = try container.decodeIfPresent(String.self, forKey: .descriptionRaw)
        stores = try container.decodeIfPresent([DAOGameDetailStores].self, forKey: .stores)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        updated = try container.decodeIfPresent(String.self, forKey: .updated)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        released = try container.decodeIfPresent(String.self, forKey: .released)
        playtime = try container.decodeIfPresent(Int.self, forKey: .playtime)
    }
    
}
