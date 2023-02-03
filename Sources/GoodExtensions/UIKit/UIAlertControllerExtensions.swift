//
//  UIAlertController.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit
import MapKit
import GRCompatible

// MARK: - Maps

public extension GRActive where Base: UIAlertController {

    // swiftlint:disable function_parameter_count

    /// Creates a `UIAlertController` instance with specified parameters.
    ///
    /// - Parameters:
    ///   - title: The title of the alert, defaults to nil.
    ///   - message: The message of the alert, defaults to nil.
    ///   - cancelString: The string value of the cancel button.
    ///   - wazeTitle: The string value of the Waze action.
    ///   - googleTitle: The string value of the Google Maps action.
    ///   - appleTitle: The string value of the Apple Maps action.
    ///   - coordinate: The location coordinates for the map actions.
    ///   - name: The name of the location, defaults to nil.
    ///   - from: The source object for the alert, defaults to nil.
    /// - Returns: An `UIAlertController` instance configured with the specified parameters.
    static func create(
        title: String? = nil,
        message: String? = nil,
        cancelString: String,
        wazeTitle: String,
        googleTitle: String,
        appleTitle: String,
        coordinate: CLLocationCoordinate2D,
        name: String?,
        from: Any? = nil
    ) -> UIAlertController {
        let controller = UIAlertController.gr.create(
            title: title,
            message: message,
            preferredStyle: .actionSheet,
            from: from
        )

        controller.addWazeAction(coordinate: coordinate, title: wazeTitle)
        controller.addGoogleMapsAction(coordinate: coordinate, title: googleTitle)
        controller.addAppleMapsAction(coordinate: coordinate, name: name, title: appleTitle)

        controller.addAction(UIAlertAction(title: cancelString, style: .cancel, handler: nil))

        return controller
    }
    // swiftlint:enable function_parameter_count

    /// Creates a `UIAlertController` instance with specified parameters.
    ///
    /// - Parameters:
    ///   - title: The title of the alert, defaults to nil.
    ///   - message: The message of the alert, defaults to nil.
    ///   - preferredStyle: The style of UIAlertViewController
    ///   - from: Present from
    /// - Returns: An `UIAlertController` instance configured with the specified parameters.
    static func create(
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style,
        from: Any? = nil
    ) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        if let button = from as? UIButton {
            controller.popoverPresentationController?.sourceView = button
            controller.popoverPresentationController?.sourceRect = button.accessibilityFrame
        } else if let view = from as? UIView {
            controller.popoverPresentationController?.sourceView = view
            controller.popoverPresentationController?.sourceRect = view.bounds
        } else if let barButtonItem = from as? UIBarButtonItem {
            controller.popoverPresentationController?.barButtonItem = barButtonItem
        }

        return controller
    }

}

fileprivate extension UIAlertController {

    /// Adds a Waze navigation action to the alert.
    ///
    /// - Parameters:
    ///   - coordinate: The destination coordinate for the navigation.
    ///   - title: The title for the navigation action in the alert.
    func addWazeAction(coordinate: CLLocationCoordinate2D, title: String) {
        // swiftlint:disable force_unwrapping
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            addAction(
                UIAlertAction(
                    title: title,
                    style: .default
                ) { _ in
                    UIApplication.shared.open(
                        URL(string: "https://waze.com/ul?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=yes")!,
                        options: [:],
                        completionHandler: nil
                    )
                }
            )
        }
    }

    /// Adds a Google Maps navigation action to the alert.
    ///
    /// - Parameters:
    ///   - coordinate: The destination coordinate for the navigation.
    ///   - title: The title for the navigation action in the alert.
    func addGoogleMapsAction(coordinate: CLLocationCoordinate2D, title: String) {
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            addAction(
                UIAlertAction(
                    title: title,
                    style: .default,
                    handler: { _ in
                        UIApplication.shared.open(
                            URL(string: "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude)")!,
                            options: [:],
                            completionHandler: nil
                        )
                    }
                )
            )
        }
    }

    /// Adds an Apple Maps navigation action to the alert.
    ///
    /// - Parameters:
    ///   - coordinate: The destination coordinate for the navigation.
    ///   - name: The name of the destination to be displayed in the maps app.
    ///   - title: The title for the navigation action in the alert.
    func addAppleMapsAction(coordinate: CLLocationCoordinate2D, name: String?, title: String) {
        if UIApplication.shared.canOpenURL(URL(string: "maps://")!) {
            addAction(
                UIAlertAction(
                    title: title,
                    style: .default,
                    handler: { _ in
                        let item = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                        item.name = name
                        item.openInMaps(
                            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        )
                    }
                )
            )
        }
        // swiftlint:enable force_unwrapping
    }

}
