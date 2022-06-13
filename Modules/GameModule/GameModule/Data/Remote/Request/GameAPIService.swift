//
//  GameAPIService.swift
//  GameModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Foundation
import Alamofire
import CoreModule

public enum GameAPIService: URLRequestConvertible {
    private static let baseURLString = NetworkConfig.getBaseUrl()
    private static let apiKey = NetworkConfig.getApiKey()
    
    case doGetGames(param: [String: Any])
    case doGetGameDetail(id: Int)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var res: (path: String, param: [String: Any]) {
        switch self {
        case .doGetGames(let param):
            return ("/games", param)
        case .doGetGameDetail(let id):
            return ("/games/\(id)", [:])
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url: URL? = try? GameAPIService.baseURLString.asURL()
        var urlRequest: URLRequest?
        // path
        urlRequest = URLRequest(url: (url?.appendingPathComponent(res.path))!)
        // request method
        urlRequest?.httpMethod = method.rawValue
        // param
        var params = res.param
        params["key"] = GameAPIService.apiKey
        urlRequest = try URLEncoding.default.encode(urlRequest!, with: params)
        return urlRequest!
    }
}
