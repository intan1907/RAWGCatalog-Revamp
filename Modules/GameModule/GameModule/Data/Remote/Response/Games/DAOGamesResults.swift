//
//  DAOGamesResults.swift
//
//  Created by Intan Nurjanah on 04/09/21
//  Copyright (c) intan3951. All rights reserved.
//

import Foundation

public class DAOGamesResults: Codable {
    
    enum CodingKeys: String, CodingKey {
        case backgroundImage = "background_image"
        case id
        case name
        case rating
    }
    
    var backgroundImage: String?
    var id: Int?
    var name: String?
    var rating: Float?
    
    init (backgroundImage: String?, id: Int?, name: String?, rating: Float?) {
        self.backgroundImage = backgroundImage
        self.id = id
        self.name = name
        self.rating = rating
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        backgroundImage = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        rating = try container.decodeIfPresent(Float.self, forKey: .rating)
    }
    
}
