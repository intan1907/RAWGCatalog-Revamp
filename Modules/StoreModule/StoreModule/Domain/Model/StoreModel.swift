//
//  StoreModel.swift
//  StoreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import Foundation

public class StoreModel: Identifiable, Equatable {
    
    public var id: Int?
    public var name: String?
    public var imageUrl: String?
    
    public static func == (lhs: StoreModel, rhs: StoreModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.imageUrl == rhs.imageUrl
    }
    
    public init(id: Int? = nil, name: String? = nil, imageUrl: String? = nil) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
    
}
