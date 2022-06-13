//
//  StoreDetailModel.swift
//  StoreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import Foundation

public class StoreDetailModel: StoreModel {
    
    public var domain: String?
    public var descriptionValue: String?
    
    public init(id: Int? = nil, name: String? = nil, imageUrl: String? = nil, domain: String? = nil, descriptionValue: String? = nil) {
        super.init(id: id, name: name, imageUrl: imageUrl)
        self.domain = domain
        self.descriptionValue = descriptionValue
    }
    
}
