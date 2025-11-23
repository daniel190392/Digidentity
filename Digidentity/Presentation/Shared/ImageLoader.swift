//
//  ImageLoader.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()
    private let dataSource: ImageDataSource

    init(dataSource: ImageDataSource = RemoteImageDataSource()) {
        self.dataSource = dataSource
    }

    func loadImage(_ url: URL) async -> UIImage? {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }
        do {
            let data = try await dataSource.fetchImageData(from: url)
            guard let image = UIImage(data: data) else {
                throw NSError(domain: "ImageLoader", code: -1)
            }

            cache.setObject(image, forKey: url as NSURL)
            return image
        } catch {
            return nil
        }
    }
}
