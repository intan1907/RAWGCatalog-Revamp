//
//  StoresTransformer.swift
//  StoreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import CoreModule

public struct StoresTransformer: ResponseMapper {
    
    public typealias Response = DAOStoresBaseClass
    public typealias Domain = [StoreModel]
    
    public init() { }
    
    public func transformResponseToDomain(response: DAOStoresBaseClass) -> [StoreModel] {
        return (response.results ?? [])
            .map { result in
                let model = StoreModel(id: result.id)
                model.imageUrl = result.imageBackground ?? ""
                model.name = result.name ?? "-"
                return model
            }
    }
    
}
