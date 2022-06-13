//
//  GenreAPIService.swift
//  GenreModule
//
//  Created by Intan Nurjanah on 20/04/22.
//

import Alamofire
import CoreModule

public enum GenreAPIService: URLRequestConvertible {
    
    private static let baseURLString = NetworkConfig.getBaseUrl()
    private static let apiKey = NetworkConfig.getApiKey()
    
    case doGetGenres
    case doGetGenreDetail(id: Int)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .doGetGenres:
            return "/genres"
        case .doGetGenreDetail(let id):
            return "/genres/\(id)"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url: URL? = try? GenreAPIService.baseURLString.asURL()
        var urlRequest: URLRequest?
        // path
        urlRequest = URLRequest(url: (url?.appendingPathComponent(self.path))!)
        // request method
        urlRequest?.httpMethod = self.method.rawValue
        // param
        urlRequest = try URLEncoding.default.encode(urlRequest!, with: ["key": GenreAPIService.apiKey])
        return urlRequest!
    }
    
}
