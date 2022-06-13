//
//  DAOGenreDetailBaseClass.swift
//
//  Created by Intan Nurjanah on 01/06/22
//  Copyright (c) . All rights reserved.
//

import Foundation

public class DAOGenreDetailBaseClass: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case descriptionValue = "description"
        case imageBackground = "image_background"
    }
    
    var name: String?
    var id: Int?
    var descriptionValue: String?
    var imageBackground: String?
    
    init (name: String?, id: Int?, descriptionValue: String?, imageBackground: String?) {
        self.name = name
        self.id = id
        self.descriptionValue = descriptionValue
        self.imageBackground = imageBackground
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        descriptionValue = try container.decodeIfPresent(String.self, forKey: .descriptionValue)
        imageBackground = try container.decodeIfPresent(String.self, forKey: .imageBackground)
    }
    
}
