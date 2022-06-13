//
//  DAOGameDetailRatings.swift
//
//  Created by Intan Nurjanah on 13/09/21
//  Copyright (c) intan3951. All rights reserved.
//

import Foundation

public class DAOGameDetailRatings: Codable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case percent
        case count
        case id
    }
    
    var title: String?
    var percent: Float?
    var count: Int?
    var id: Int?
    
    public init (title: String?, percent: Float?, count: Int?, id: Int?) {
        self.title = title
        self.percent = percent
        self.count = count
        self.id = id
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        percent = try container.decodeIfPresent(Float.self, forKey: .percent)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
    }
    
}
