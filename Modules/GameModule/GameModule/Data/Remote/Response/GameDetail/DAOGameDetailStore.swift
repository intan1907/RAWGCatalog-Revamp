//
//  DAOGameDetailStore.swift
//
//  Created by Intan Nurjanah on 13/09/21
//  Copyright (c) intan3951. All rights reserved.
//

import Foundation

public class DAOGameDetailStore: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
    }
    
    var name: String?
    var id: Int?
    
    public init (name: String?, id: Int?) {
        self.name = name
        self.id = id
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
    }
    
}
