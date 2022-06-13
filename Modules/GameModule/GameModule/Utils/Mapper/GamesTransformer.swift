//
//  GamesTransformer.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Foundation
import CoreModule

public struct GamesTransformer: ParamMapper & ResponseMapper {
    
    public typealias DomainParam = GameParamModel
    public typealias RequestParam = [String: Any]
    
    public typealias Response = DAOGamesBaseClass
    public typealias Domain = GamesModel
    
    public init() { }
    
    public func transformDomainParamToRequest(param: GameParamModel) -> [String: Any] {
        var params: [String: Any] = [:]
        
        if let page = param.page {
            params["page"] = page
        }
        
        if let pageSize = param.pageSize {
            params["page_size"] = pageSize
        }
        
        if let searchKeyword = param.search {
            params["search"] = searchKeyword
        }
        
        if let stores = param.store {
            params["stores"] = "\(stores)"
        }
        
        if let genres = param.genre {
            params["genres"] = "\(genres)"
        } else if let genreName = param.genreName {
            params["genres"] = genreName
        }
        
        if let ordering = param.ordering?.rawValue {
            params["ordering"] = ordering
        }
        
        return params
    }
    
    public func transformResponseToDomain(response: DAOGamesBaseClass) -> GamesModel {
        let list: [GameModel] = (response.results ?? []).map { result -> GameModel in
            return GameModel(id: result.id, imageUrl: result.backgroundImage ?? "", name: result.name ?? "-", rating: Double(result.rating ?? 0))
        }
        return GamesModel(totalData: response.count, games: list)
    }
    
}
