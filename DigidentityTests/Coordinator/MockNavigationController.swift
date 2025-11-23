//
//  MockNavigationController.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 23/11/25.
//

import UIKit

final class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    var pushCompletion: (() -> Void)?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        pushCompletion?()
    }
}
