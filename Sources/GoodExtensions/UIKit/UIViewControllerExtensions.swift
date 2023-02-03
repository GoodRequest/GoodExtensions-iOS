//
//  ViewController.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit
import GRCompatible
import Combine

// MARK: - Embedable

public extension GRActive where Base: UIViewController {

    /// Adds a child view controller to the current view controller's hierarchy.
    ///
    /// - Parameters:
    ///   - viewController: The child view controller to be added to the current view controller's hierarchy.
    ///   - containerView: The view in which the child view controller's view should be embedded.
    /// - Note:
    ///   - The child view controller's view is added to the specified container view and its frame is set to match the container view's bounds.
    ///   - The child view controller is added to the current view controller's hierarchy using `addChild` and `didMove` methods.
    func embed(viewController: UIViewController, in containerView: UIView) {
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        base.addChild(viewController)
        viewController.didMove(toParent: base)
    }
    
}

// MARK: - Instantiable

public extension GRActive where Base: UIViewController {

    /// Makes an instance of the `UIViewController` class with specified name.
    ///
    /// - Parameter name: The name of the storyboard. Defaults to the name of the base class.
    /// - Returns: The instance of the class.
    static func makeInstance(name: String? = nil) -> Base {
        var viewControllerName: String
        if let name = name {
            viewControllerName = name
        } else {
            viewControllerName = Base.gr.typeName
        }
        
        let storyboard = UIStoryboard(name: viewControllerName, bundle: nil)
        guard let instance = storyboard.instantiateInitialViewController() as? Base
                ?? instantiate(storyboard: storyboard, name: viewControllerName)
        else { fatalError("Could not make instance of \(String(describing: Base.self))") }
        return instance
    }

    /// Helper method to instantiate view controller in storyboard.
    ///
    /// - Parameters:
    ///   - storyboard: The storyboard.
    ///   - name: The name of the storyboard.
    /// - Returns: The instance of the base class if it exists in the storyboard.
    private static func instantiate(storyboard: UIStoryboard, name: String) -> Base? {
        if #available(iOS 13.0, *) {
            return storyboard.instantiateViewController(identifier: name) as? Base
        } else {
            return nil
        }
    }
    
}

/// KeyboardInfo struct represents information about a keyboard animation event.
public struct KeyboardInfo: Equatable {

    /// indicates whether two KeyboardInfo instances are equal.
    public static func == (lhs: KeyboardInfo, rhs: KeyboardInfo) -> Bool {
        return lhs.height == rhs.height
    }

    /// Height of the keyboard.
    public let height: CGFloat

    /// Duration of the keyboard animation event.
    public let duration: Double

    /// The animation curve used during the keyboard animation event.
    public let curve: UIView.AnimationOptions

    /// An instance of KeyboardInfo with height set to `0,` duration set to `0` and curve set to `.curveEaseInOut`
    public static let emptyInfo = KeyboardInfo(height: 0.0, duration: 0.0, curve: .curveEaseInOut)

}

/// An enum that describes the state of the keyboard.
public enum KeyboardState: Equatable {

    /// The keyboard is hidden.
    case hidden(KeyboardInfo)

    /// The keyboard is expanded.
    case expanded(KeyboardInfo)

    public var isHidden: Bool {
        if case KeyboardState.hidden = self {
            return true
        } else {
            return false
        }
    }

}

public extension GRActive where Base: UIViewController {

    /// A publisher that emits keyboard state changes.
    var keyboardStatePublisher: AnyPublisher<KeyboardState, Never> {
        let showNotification = UIApplication.keyboardWillChangeFrameNotification
        let keyboardWillShowPublisher = NotificationCenter.default.publisher(for: showNotification)
            .map { keyboard -> KeyboardState in
                let height = (keyboard.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
                let duration = (keyboard.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.5
                // swiftlint:disable line_length
                let animationCurveRawNSN = keyboard.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
                let curve = UIView.AnimationOptions(rawValue: animationCurveRaw)
                // swiftlint:enable line_length
                let info = KeyboardInfo(height: height, duration: duration, curve: curve)
                return .expanded(info)
            }

        let hideNotification = UIApplication.keyboardWillHideNotification
        let keyboardWillHidePublisher = NotificationCenter.default.publisher(for: hideNotification)
            .map { keyboard -> KeyboardState in
                let height = 0.0
                let duration = (keyboard.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat) ?? 0.5
                // swiftlint:disable line_length
                let animationCurveRawNSN = keyboard.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
                let curve = UIView.AnimationOptions(rawValue: animationCurveRaw)
                // swiftlint:enable line_length
                let info = KeyboardInfo(height: height, duration: duration, curve: curve)
                return .hidden(info)
            }

        return Publishers.Merge(keyboardWillShowPublisher, keyboardWillHidePublisher)
            .eraseToAnyPublisher()
    }

    /// A publisher that emits the height of the keyboard when it changes.
    var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        keyboardStatePublisher
        .map {
            switch $0 {
            case .hidden(let info), .expanded(let info):
                return info.height
            }
        }
        .eraseToAnyPublisher()
    }
    
}
