//
//  GesturePublisher.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit
import Combine
import GRCompatible

///Defines different types of UIGestureRecognizer objects
public enum GestureType {

    case tap(UITapGestureRecognizer = .init())
    case swipe(UISwipeGestureRecognizer = .init())
    case longPress(UILongPressGestureRecognizer = .init())
    case pan(UIPanGestureRecognizer = .init())
    case pinch(UIPinchGestureRecognizer = .init())
    case edge(UIScreenEdgePanGestureRecognizer = .init())

    public func get() -> UIGestureRecognizer {
        switch self {
        case let .tap(tapGesture):
            return tapGesture

        case let .swipe(swipeGesture):
            return swipeGesture

        case let .longPress(longPressGesture):
            return longPressGesture

        case let .pan(panGesture):
            return panGesture

        case let .pinch(pinchGesture):
            return pinchGesture

        case let .edge(edgePanGesture):
            return edgePanGesture
       }
    }
}

/// Structs that is used for publishing `GestureType` events.
@available(iOS 13.0, *)
public struct GesturePublisher: Publisher {

    /// The type of values being published.
    public typealias Output = GestureType

    /// The type of errors that this publisher might emit. (Never in this case)
    public typealias Failure = Never

    /// The view that the gesture recognizer will be attached to.
    private let view: UIView

    /// The type of gesture to be recognized.
    private let gestureType: GestureType

    /// Initializes a new `GesturePublisher` instance with a given `UIView` and `GestureType`.
    ///
    /// - Parameters:
    ///   - view: The view that the gesture recognizer will be attached to.
    ///   - gestureType: The type of gesture to be recognized.
    public init(view: UIView, gestureType: GestureType) {
        self.view = view
        self.gestureType = gestureType
    }

    /// This method is called when a subscriber subscribes to the publisher.
    ///
    /// - Parameter subscriber: The subscriber that wants to receive values from the publisher.
    public func receive<S>(
    	subscriber: S
    ) where S: Subscriber, GesturePublisher.Failure == S.Failure, GesturePublisher.Output == S.Input {
        let subscription = GestureSubscriber(
            subscriber: subscriber,
            view: view,
            gestureType: gestureType
        )
        subscriber.receive(subscription: subscription)
    }
}

@available(iOS 13.0, *)
public extension GRActive where Base: UIView {

    func gesturePublisher(_ gestureType: GestureType) -> GesturePublisher {
        GesturePublisher(view: base, gestureType: gestureType)
    }

}
