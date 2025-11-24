//
//  APIError.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

enum APIError: Error {
    case badURL
    case badServerResponse(statusCode: Int)
    case decodingError(underlying: Error)
    case networkError(underlying: Error)
    case databaseError(underlying: Error)
}
