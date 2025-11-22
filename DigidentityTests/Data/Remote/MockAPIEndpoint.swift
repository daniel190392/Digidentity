//
//  MockAPIEndpoint.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Foundation

@testable import Digidentity

enum MockAPIEndpoint: APIEndpoint {
    case getMethod
    case postMethod
    case putMethod
    case deleteMethod

    var baseURL: String {
        return "baseUrl"
    }

    var path: String {
        switch self {
        case .getMethod:
            return "/get"
        case .postMethod:
            return "/post"
        case .putMethod:
            return "/put"
        case .deleteMethod:
            return "/delete"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getMethod:
            return .get
        case .postMethod:
            return .post
        case .putMethod:
            return .put
        case .deleteMethod:
            return .delete
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getMethod:
            return nil
        case .postMethod:
            return ["NewHeader": "NewValue"]
        case .putMethod:
            return nil
        case .deleteMethod:
            return nil
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }
}
