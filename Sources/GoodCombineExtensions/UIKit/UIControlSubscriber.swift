//
//  UIControlSubscriber.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit
import Combine

// swiftlint:disable line_length
@available(iOS 13.0, *)
final public class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
// swiftlint:enable line_length

    private var subscriber: SubscriberType?
    private weak var control: Control?

    init(subscriber: SubscriberType, control: Control?, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control

        control?.addTarget(self, action: #selector(eventHandler), for: event)
    }

    public func request(_ demand: Subscribers.Demand) {

    }

    public func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        guard let control = control else { return }
        _ = subscriber?.receive(control)
    }
}

// swiftlint:disable line_length

/// A subscription to a UIControl's value property through a key path.
/// The subscription listens to specified UIControl events and emits the value of the specified key path whenever the events are triggered.
/// The subscription will emit the current value of the key path upon request of demand, and the emission of the key path's value will persist until the subscription is cancelled.
@available(iOS 13.0, *)
public final class UIControlKeyPathSubscription<S: Subscriber, Control: UIControl, Value>: Combine.Subscription where S.Input == Value {

// swiftlint:enable line_length

    /// The subscriber to receive values from the control's key path.
    private var subscriber: S?

    /// The UIControl being subscribed to.
    weak private var control: Control?

    /// The key path of the control's value property being subscribed to.
    let keyPath: KeyPath<Control, Value>

    private var didEmitInitial = false

    /// The event(s) being listened to on the control.
    private let event: Control.Event

    /// Initializes a new instance of `UIControlKeyPathSubscription`.
    ///
    /// - Parameters:
    ///   - subscriber: The subscriber to receive values from the control's key path.
    ///   - control: The UIControl being subscribed to.
    ///   - event: The event(s) being listened to on the control.
    ///   - keyPath: The key path of the control's value property being subscribed to.
    init(subscriber: S, control: Control, event: Control.Event, keyPath: KeyPath<Control, Value>) {
        self.subscriber = subscriber
        self.control = control
        self.keyPath = keyPath
        self.event = event
        control.addTarget(self, action: #selector(handleEvent), for: event)
    }

    /// Requests values from the control's key path.
    ///
    /// - Parameter demand: The demand for values from the control's key path.
    public func request(_ demand: Subscribers.Demand) {
        // Emit initial value upon first demand request
        if !didEmitInitial,
            demand > .none,
            let control = control,
            let subscriber = subscriber {
            _ = subscriber.receive(control[keyPath: keyPath])
            didEmitInitial = true
        }

        // We don't care about the demand at this point.
        // As far as we're concerned - UIControl events are endless until the control is deallocated.
    }

    /// Cancels the subscription to the control's key path.
    public func cancel() {
        control?.removeTarget(self, action: #selector(handleEvent), for: event)
        subscriber = nil
    }

    @objc private func handleEvent() {
        guard let control = control else { return }

        _ = subscriber?.receive(control[keyPath: keyPath])
    }

}
