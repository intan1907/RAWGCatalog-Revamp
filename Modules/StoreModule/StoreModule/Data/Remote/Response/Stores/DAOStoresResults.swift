//
//  DAOStoresResults.swift
//
//  Created by Intan Nurjanah on 25/04/22
//  Copyright (c) . All rights reserved.
//

import Foundation

public class DAOStoresResults: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case imageBackground = "image_background"
    }
    
    var name: String?
    var id: Int?
    var imageBackground: String?
    
    public init (name: String?, id: Int?, imageBackground: String?) {
        self.name = name
        self.id = id
        self.imageBackground = imageBackground
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        imageBackground = try container.decodeIfPresent(String.self, forKey: .imageBackground)
    }
    
}
