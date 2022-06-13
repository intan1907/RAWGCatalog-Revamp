//
//  GenreDetailTransformer.swift
//  GenreModule
//
//  Created by Intan Nurjanah on 01/06/22.
//

import Foundation
import CoreModule

public struct GenreDetailTransformer: ResponseMapper {
    
    public typealias Response = DAOGenreDetailBaseClass
    public typealias Domain = GenreDetailModel
    
    public init() { }
    
    public func transformResponseToDomain(response: DAOGenreDetailBaseClass) -> GenreDetailModel {
        let model = GenreDetailModel(id: response.id)
        model.imageUrl = response.imageBackground ?? ""
        model.name = response.name ?? "-"
        model.descriptionValue = response.descriptionValue ?? "-"
        return model
    }
    
}
