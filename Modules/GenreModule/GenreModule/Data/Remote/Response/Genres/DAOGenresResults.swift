//
//  DAOGenresResults.swift
//
//  Created by Intan Nurjanah on 25/04/22
//  Copyright (c) . All rights reserved.
//

import Foundation

class DAOGenresResults: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageBackground = "image_background"
    }
    
    var id: Int?
    var name: String?
    var imageBackground: String?
    
    init (id: Int?, name: String?, imageBackground: String?) {
        self.id = id
        self.name = name
        self.imageBackground = imageBackground
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        imageBackground = try container.decodeIfPresent(String.self, forKey: .imageBackground)
    }
    
}
