//
//  StoreDetailTransformer.swift
//  StoreModule
//
//  Created by Intan Nurjanah on 25/04/22.
//

import CoreModule

public struct StoreDetailTransformer: ResponseMapper {
    
    public typealias Response = DAOStoreDetailBaseClass
    public typealias Domain = StoreDetailModel
    
    public init() { }
    
    public func transformResponseToDomain(response: DAOStoreDetailBaseClass) -> StoreDetailModel {
        let model = StoreDetailModel(id: response.id)
        model.imageUrl = response.imageBackground ?? ""
        model.name = response.name ?? "-"
        model.domain = response.domain ?? "-"
        model.descriptionValue = response.descriptionValue ?? "-"
        return model
    }
    
}
