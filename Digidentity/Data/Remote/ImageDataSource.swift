//
//  ImageDataSource.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import UIKit

protocol ImageDataSource {
    func fetchImageData(from url: URL) async throws -> Data
}

final class RemoteImageDataSource: ImageDataSource {
    func fetchImageData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
