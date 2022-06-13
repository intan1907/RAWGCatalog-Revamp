//
//  StoreAPIService.swift
//  StoreModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Foundation
import Alamofire
import CoreModule

public enum StoreAPIService: URLRequestConvertible {
    
    private static let baseURLString = NetworkConfig.getBaseUrl()
    private static let apiKey = NetworkConfig.getApiKey()
    
    case doGetStores
    case doGetStoreDetail(id: Int)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .doGetStores:
            return ("/stores")
        case .doGetStoreDetail(let id):
            return ("/stores/\(id)")
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url: URL? = try? StoreAPIService.baseURLString.asURL()
        var urlRequest: URLRequest?
        // path
        urlRequest = URLRequest(url: (url?.appendingPathComponent(self.path))!)
        // request method
        urlRequest?.httpMethod = method.rawValue
        // param
        urlRequest = try URLEncoding.default.encode(urlRequest!, with: ["key": StoreAPIService.apiKey])
        return urlRequest!
    }
    
}
