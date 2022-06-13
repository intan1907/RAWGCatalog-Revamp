//
//  DAOStoreDetailBaseClass.swift
//
//  Created by Intan Nurjanah on 25/04/22
//  Copyright (c) . All rights reserved.
//

import Foundation

public class DAOStoreDetailBaseClass: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case descriptionValue = "description"
        case imageBackground = "image_background"
        case name
        case domain
    }
    
    var id: Int?
    var descriptionValue: String?
    var imageBackground: String?
    var name: String?
    var domain: String?
    
    public init (id: Int?, descriptionValue: String?, imageBackground: String?, name: String?, domain: String?) {
        self.id = id
        self.descriptionValue = descriptionValue
        self.imageBackground = imageBackground
        self.name = name
        self.domain = domain
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        descriptionValue = try container.decodeIfPresent(String.self, forKey: .descriptionValue)
        imageBackground = try container.decodeIfPresent(String.self, forKey: .imageBackground)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        domain = try container.decodeIfPresent(String.self, forKey: .domain)
    }
    
}
