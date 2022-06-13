//
//  GameDetailModel.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Foundation

public class GameDetailModel: GameModel, NSCopying {
    
    public var metacritic: Int?
    public var released: String?
    public var platforms: String?
    public var genres: String?
    public var lastModified: String?
    public var ratingCategory: String?
    public var about: String?
    public var playtime: Int?
    public var stores: String?
    public var isFavorite: Bool?
    
    public init(id: Int? = nil, imageUrl: String? = nil, image: Data? = nil, name: String? = nil, lastModified: String? = nil, ratingCategory: String? = nil, about: String? = nil, rating: Double? = nil, released: String? = nil, platforms: String? = nil, genres: String? = nil, playtime: Int? = nil, metacritic: Int? = nil, stores: String? = nil, isFavorite: Bool? = nil) {
        super.init(id: id, imageUrl: imageUrl, image: image, name: name, rating: rating)
        self.lastModified = lastModified
        self.ratingCategory = ratingCategory
        self.about = about
        self.playtime = playtime
        self.metacritic = metacritic
        self.released = released
        self.platforms = platforms
        self.genres = genres
        self.stores = stores
        self.isFavorite = isFavorite
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = GameDetailModel(id: self.id, imageUrl: self.imageUrl, image: self.image, name: self.name, lastModified: self.lastModified, ratingCategory: self.ratingCategory, about: self.about, rating: self.rating, released: self.released, platforms: self.platforms, genres: self.genres, playtime: self.playtime, metacritic: self.metacritic, stores: self.stores, isFavorite: self.isFavorite)
        return copy
    }
    
    public func getRatingCategoryWithEmoji() -> String {
        guard let ratingCategory = self.ratingCategory,
              !ratingCategory.isEmpty && ratingCategory != "-"
        else {
            return "-"
        }
        var emoji = ""
        switch ratingCategory.lowercased() {
        case "exceptional":
            emoji = "\u{1F3AF}" // direct hit
        case "recommended":
            emoji = "\u{1F44D}" // thumbs up
        case "meh":
            emoji = "\u{1F611}" // expressionless
        case "skip":
            emoji = "\u{1F6AB}" // no entry
        default:
            break
        }
        return emoji.isEmpty ? ratingCategory : "\(ratingCategory) \(emoji)"
    }
    
    public func getFormattedPlaytime() -> String {
        guard let playtime = self.playtime, playtime > 0 else {
            return "Unknown"
        }

        return "\(playtime) minute(s)"
    }
    
    public func getFormattedMetacritic() -> String {
        guard let rate = self.metacritic, rate != 0 else {
            return "Not rated"
        }
        
        return "\(rate)"
    }
    
    public func getArrayStores() -> [String] {
        return self.stores?.components(separatedBy: ",") ?? []
    }
    
}
