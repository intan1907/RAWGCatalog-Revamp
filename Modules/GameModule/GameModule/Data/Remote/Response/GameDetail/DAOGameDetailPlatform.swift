//
//  DAOGameDetailPlatform.swift
//
//  Created by Intan Nurjanah on 13/09/21
//  Copyright (c) intan3951. All rights reserved.
//

import Foundation

public class DAOGameDetailPlatform: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    var id: Int?
    var name: String?
    
    public init (id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }
    
}
