//
//  DAOGameDetailParentPlatforms.swift
//
//  Created by Intan Nurjanah on 13/09/21
//  Copyright (c) intan3951. All rights reserved.
//

import Foundation

public class DAOGameDetailParentPlatforms: Codable {
    
    enum CodingKeys: String, CodingKey {
        case platform
    }
    
    var platform: DAOGameDetailPlatform?
    
    public init (platform: DAOGameDetailPlatform?) {
        self.platform = platform
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        platform = try container.decodeIfPresent(DAOGameDetailPlatform.self, forKey: .platform)
    }
    
}
