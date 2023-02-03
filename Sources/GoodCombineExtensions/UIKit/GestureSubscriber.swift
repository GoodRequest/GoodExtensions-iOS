//
//  GestureSubscriber.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//
import UIKit
import Combine

/// This class is used to subscribe to the gesture events on a `UIView` and receive notifications when the specified gesture occurs.
@available(iOS 13.0, *)
public class GestureSubscriber<S: Subscriber>: Subscription where S.Input == GestureType, S.Failure == Never {

    private var subscriber: S?
    private var gestureType: GestureType
    private weak var view: UIView?

    /// Initializes a `GestureSubscriber` instance with a `subscriber`, `view`, and `gestureType`.
    ///
    /// - Parameters:
    ///   - subscriber: The subscriber to receive gesture events.
    ///   - view: The view on which the gesture is added.
    ///   - gestureType: The gesture type to subscribe to.
    public init(subscriber: S, view: UIView, gestureType: GestureType) {
        self.subscriber = subscriber
        self.view = view
        self.gestureType = gestureType
        configureGesture(gestureType)
    }

    /// Configures the gesture on the view.
    ///
    /// - Parameter gestureType:  The gesture type to subscribe to.
    private func configureGesture(_ gestureType: GestureType) {
        let gesture = gestureType.get()
        gesture.addTarget(self, action: #selector(handler))
        view?.addGestureRecognizer(gesture)
    }

    /// This method is called to request `demand` units of elements from the publisher.
    ///
    /// - Parameter demand: The requested number of elements.
    public func request(_ demand: Subscribers.Demand) {

    }

    /// Method to cancel the subscription.
    public func cancel() {
        subscriber = nil
    }

    /// Send the gesture type to the subscriber.
    @objc private func handler() {
        _ = subscriber?.receive(gestureType)
    }
}
