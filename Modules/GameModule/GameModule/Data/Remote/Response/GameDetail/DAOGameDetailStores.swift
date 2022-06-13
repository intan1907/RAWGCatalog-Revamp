//
//  DAOGameDetailStores.swift
//
//  Created by Intan Nurjanah on 13/09/21
//  Copyright (c) intan3951. All rights reserved.
//

import Foundation

public class DAOGameDetailStores: Codable {
    
    enum CodingKeys: String, CodingKey {
        case url
        case store
        case id
    }
    
    var url: String?
    var store: DAOGameDetailStore?
    var id: Int?
    
    public init (url: String?, store: DAOGameDetailStore?, id: Int?) {
        self.url = url
        self.store = store
        self.id = id
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        store = try container.decodeIfPresent(DAOGameDetailStore.self, forKey: .store)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
    }
    
}
