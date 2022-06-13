//
//  DAOStoresBaseClass.swift
//
//  Created by Intan Nurjanah on 25/04/22
//  Copyright (c) . All rights reserved.
//

import Foundation

public class DAOStoresBaseClass: Codable {
    
    enum CodingKeys: String, CodingKey {
        case results
        case count
    }
    
    var results: [DAOStoresResults]?
    var count: Int?
    
    public init (results: [DAOStoresResults]?, count: Int?) {
        self.results = results
        self.count = count
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decodeIfPresent([DAOStoresResults].self, forKey: .results)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
    }
    
}
