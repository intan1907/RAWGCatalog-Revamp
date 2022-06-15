//
//  GameModel.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Foundation

open class GameModel: Identifiable, Equatable {
    
    public var id: Int?
    public var imageUrl: String?
    public var image: Data?
    public var name: String?
    public var rating: Double?
    
    public static func == (lhs: GameModel, rhs: GameModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.image == rhs.image &&
        lhs.name == rhs.name &&
        lhs.rating == rhs.rating
    }
    
    public init(id: Int? = nil, imageUrl: String? = nil, image: Data? = nil, name: String? = nil, released: String? = nil, rating: Double? = nil) {
        self.id = id
        self.imageUrl = imageUrl
        self.image = image
        self.name = name
        self.rating = rating
    }
    
    public func getFormattedRating() -> String {
        guard let rating = self.rating, rating != 0 else {
            return "Not rated"
        }
        
        return "\(String(format: "%.2f", rating))"
    }
    
}
