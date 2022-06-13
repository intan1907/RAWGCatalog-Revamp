//
//  GameParamModel.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Foundation

public class GameParamModel {
    
    public var page: Int?
    public var pageSize: Int?
    public var search: String?
    public var store: Int?
    public var storeName: String?
    public var genre: Int?
    public var genreName: String?
    public var ordering: GameOrderingOption?
    
    public init(page: Int? = nil, pageSize: Int? = nil, search: String? = nil, store: Int? = nil, storeName: String? = nil, genre: Int? = nil, genreName: String? = nil, ordering: GameOrderingOption? = nil) {
        self.page = page
        self.pageSize = pageSize
        self.search = search
        self.store = store
        self.storeName = storeName
        self.genre = genre
        self.genreName = genreName
        self.ordering = ordering
    }
    
}

public enum GameOrderingOption: String, CaseIterable {
    
    case added = "-added"
    case name = "name"
    case updated = "-updated"
    case released = "-released"
    case rating = "-rating"
    case metacritic = "-metacritic"
    
    public var title: String {
        switch self {
        case .added:
            return "Default"
        case .name:
            return "Name"
        case .updated:
            return "Latest Updated"
        case .released:
            return "Latest Released"
        case .rating:
            return "Highest Rating"
        case .metacritic:
            return "Highest Metacritic"
        }
    }
    
}
