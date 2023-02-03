//
//  UINavigationController.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit
import GRCompatible

// MARK: - Navigation Controller

public extension GRActive where Base: UINavigationController {

    /// Push a given UIViewController to its stack
    /// 
    /// - Parameters:
    ///   - viewController: A `UIViewController` instance that is to be pushed onto the navigation stack.
    ///   - animated: A `Boolean` indicating whether to animate the transition.
    ///   - completion: A closure that is executed after the push animation completes.
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        base.pushViewController(viewController, animated: animated)

        guard animated, let coordinator = base.transitionCoordinator else {
            completion()
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }

}
