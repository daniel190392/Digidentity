//
//  DefaultCatalogRepository.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import Foundation

class DefaultCatalogRepository: CatalogRepository {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func getCatalog() async -> Result<[Item], APIError> {
        let apiClient: CatalogAPI = .items(sinceId: nil, maxId: nil)

        guard let request = APIRequestBuilder.shared.buildRequest(for: apiClient) else {
            return .failure(.badURL)
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                let status = (response as? HTTPURLResponse)?.statusCode ?? -1
                return .failure(.badServerResponse(statusCode: status))
            }

            return Result {
                let dtos = try JSONDecoder().decode([ItemDTO].self, from: data)
                return dtos.map { $0.toEntity() }
            }
            .mapError { .decodingError(underlying: $0) }
        } catch {
            return .failure(.networkError(underlying: error))
        }
    }
}
