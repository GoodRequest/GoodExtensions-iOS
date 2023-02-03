//
//  UIApplication.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit
import MapKit
import GRCompatible

/// Enum representing different types of URLs that can be opened by the UIApplication.
public enum UIApplicationUrlType {

    /// A case representing an Instagram media URL with a given media `id`.
    case instagramMedia(id: String)

    /// A case representing a teleprompt URL with a given `number`.
    case telepromt(number: String)

    /// A case representing the device's settings URL.
    case settings
}

public extension GRActive where Base: UIApplication {

    /// A computed property to access the current status bar frame of the app.
    @available(iOS 13.0, *)
    var currentStatusBarFrame: CGRect? {
        return activeWindow?.windowScene?.statusBarManager?.statusBarFrame
    }

    /// A computed property to access the active window in the app.
    @available(iOS 13.0, *)
    var activeWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene }
            .flatMap { $0 as? UIWindowScene }?
            .windows
            .first(where: \.isKeyWindow)
    }

    // MARK: - URL handling

    // swiftlint:disable force_unwrapping

    /// A computed property to check if Instagram app is installed on the device and can be opened.
    var canOpenInstagram: Bool {
        return base.canOpenURL(URL(string: "instagram://")!)
    }
    // swiftlint:enable force_unwrapping


    /// A method to open different types of URLs.
    ///
    /// - Parameter urlType: The type of URL to be opened.
    func open(_ urlType: UIApplicationUrlType) {
        switch urlType {
        case .instagramMedia(let id):
            safeOpen(URL(string: "instagram://media?id=\(id)"))

        case .telepromt(let number):
            safeOpen(URL(string: "telprompt://\(number.gr.removeWhiteSpacesAndNewlines)"))

        case .settings:
            safeOpen(URL(string: UIApplication.openSettingsURLString))
        }
    }

    /// A helper method to open the passed URL safely by checking if it can be opened.
    ///
    /// - Parameter url: The URL to be opened.
    /// - Parameter options: The options for opening the URL.
    /// - Parameter completionHandler: A completion handler to be called after the URL is opened.
    func safeOpen(
        _ url: URL?,
        options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
        completionHandler completion: ((Bool) -> Void)? = nil
    ) {
        if let url = url, base.canOpenURL(url) {
            base.open(url, options: options, completionHandler: completion)
        }
    }

}
