//
//  NetworkMonitor.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 24/11/25.
//

import Network

protocol NetworkChecking {
    var isConnected: Bool { get }
}

final class NetworkMonitor: NetworkChecking {

    static let shared = NetworkMonitor()

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    private(set) var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
