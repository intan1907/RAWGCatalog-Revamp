//
//  DAOGamesBaseClass.swift
//
//  Created by Intan Nurjanah on 04/09/21
//  Copyright (c) intan3951. All rights reserved.
//

import Foundation

public class DAOGamesBaseClass: Codable {
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
    
    var count: Int?
    var results: [DAOGamesResults]?
    
    init (count: Int?, results: [DAOGamesResults]?) {
        self.count = count
        self.results = results
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
        results = try container.decodeIfPresent([DAOGamesResults].self, forKey: .results)
    }
    
}
