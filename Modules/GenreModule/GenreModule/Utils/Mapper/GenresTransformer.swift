//
//  GenresTransformer.swift
//  
//
//  Created by Intan Nurjanah on 25/04/22.
//

import CoreModule

public struct GenresTransformer: ResponseMapper {
    
    public typealias Response = DAOGenresBaseClass
    public typealias Domain = [GenreModel]
    
    public init() { }
    
    public func transformResponseToDomain(response: DAOGenresBaseClass) -> [GenreModel] {
        return (response.results ?? [])
            .map { result in
                let model = GenreModel(id: result.id)
                model.imageUrl = result.imageBackground ?? ""
                model.name = result.name ?? "-"
                return model
            }
    }
    
}
