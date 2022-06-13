//
//  GenreDetailModel.swift
//  GenreModule
//
//  Created by Intan Nurjanah on 01/06/22.
//

import Foundation

public class GenreDetailModel: GenreModel {
    
    public var descriptionValue: String?
    
    public init(id: Int? = nil, name: String? = nil, imageUrl: String? = nil, image: Data? = nil, descriptionValue: String? = nil) {
        super.init(id: id, name: name, imageUrl: imageUrl, image: image)
        self.descriptionValue = descriptionValue
    }
    
}
