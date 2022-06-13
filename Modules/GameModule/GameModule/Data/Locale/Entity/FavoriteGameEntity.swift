//
//  FavoriteGameEntity.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Foundation
import RealmSwift

public class FavoriteGameEntity: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var image: Data?
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var lastModified: String = ""
    @objc dynamic var ratingCategory: String = ""
    @objc dynamic var about: String = ""
    @objc dynamic var released: String = ""
    @objc dynamic var rating: Double = 0
    @objc dynamic var playtime: Int = 0
    @objc dynamic var metacritic: Int = 0
    @objc dynamic var platforms: String = ""
    @objc dynamic var genres: String = ""
    @objc dynamic var stores: String = ""
    @objc dynamic var createdDate: Date = Date()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
