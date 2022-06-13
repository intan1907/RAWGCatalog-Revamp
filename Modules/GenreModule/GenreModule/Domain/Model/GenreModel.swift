//
//  GenreModel.swift
//  GenreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import Foundation

public class GenreModel: Identifiable, Equatable {
    
    public var id: Int?
    public var name: String?
    public var imageUrl: String?
    public var image: Data?
    
    public static func == (lhs: GenreModel, rhs: GenreModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.image == rhs.image
    }
    
    public init(id: Int? = nil, name: String? = nil, imageUrl: String? = nil, image: Data? = nil) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.image = image
    }
    
}
