//
//  SFSafariViewController.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit
import SafariServices
import GRCompatible

public extension GRActive where Base: SFSafariViewController {

    /// Creates a new instance of `SFSafariViewController` with a specified URL and preferred control tint color.
    ///
    /// - Parameters:
    ///   - url: The URL to be loaded in the Safari View Controller.
    ///   - preferredControlTintColor: The preferred control tint color to be used in the navigation bar and toolbar of the Safari View Controller.
    /// - Returns: A new instance of `SFSafariViewController` with the specified URL and preferred control tint color.
    static func `default`(url: URL, preferredControlTintColor: UIColor) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.preferredControlTintColor = preferredControlTintColor
        return controller
    }

}
