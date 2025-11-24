//
//  MockNetworkChecking.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 24/11/25.
//

import Foundation

@testable import Digidentity

final class MockNetworkChecking: NetworkChecking {
    var isConnected: Bool = true
}
