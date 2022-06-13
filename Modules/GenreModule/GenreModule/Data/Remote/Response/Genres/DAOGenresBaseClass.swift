//
//  DAOGenresBaseClass.swift
//
//  Created by Intan Nurjanah on 25/04/22
//  Copyright (c) . All rights reserved.
//

import Foundation

public class DAOGenresBaseClass: Codable {
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
    
    var count: Int?
    var results: [DAOGenresResults]?
    
    init (count: Int?, results: [DAOGenresResults]?) {
        self.count = count
        self.results = results
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
        results = try container.decodeIfPresent([DAOGenresResults].self, forKey: .results)
    }
    
}
