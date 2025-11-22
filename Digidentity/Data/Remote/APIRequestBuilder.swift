//
//  APIRequest.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Foundation

class APIRequestBuilder {
    static let shared = APIRequestBuilder()

    private var globalToken: String = ""

    func setGlobalToken(_ token: String) {
        self.globalToken = token
    }

    func buildRequest(for api: APIEndpoint) -> URLRequest? {
        guard let url = URL(string: api.baseURL + api.path) else { return nil }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = api.queryItems

        guard let finalURL = components?.url else { return nil }

        var request = URLRequest(url: finalURL)
        request.httpMethod = api.method.rawValue

        api.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.setValue(globalToken, forHTTPHeaderField: "Authorization")

        return request
    }
}
