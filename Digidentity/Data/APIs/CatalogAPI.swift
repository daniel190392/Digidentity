//
//  CatalogAPI.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Foundation

enum CatalogAPI: APIEndpoint {
    case items(sinceId: String? = nil, maxId: String? = nil)

    var baseURL: String {
        return "https://marlove.net/e/mock/v1"
    }

    var path: String {
        return "/items"
    }

    var method: HTTPMethod {
        return .get
    }

    var headers: [String: String]? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .items(let sinceId, let maxId):
            var params: [URLQueryItem] = []
            if let sinceId = sinceId {
                params.append(URLQueryItem(name: "since_id", value: sinceId))
            }
            if let maxId = maxId {
                params.append(URLQueryItem(name: "max_id", value: maxId))
            }
            return params.isEmpty ? nil : params
        }
    }
}
