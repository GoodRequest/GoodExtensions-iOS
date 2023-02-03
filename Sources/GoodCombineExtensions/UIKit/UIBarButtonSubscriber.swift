//
//  UIBarButtonSubscriber.swift
//  GoodCombineExtensions
//
//  Created by GoodRequest on 26/08/2021.
//

import UIKit
import Combine

// swiftlint:disable line_length

/// UIBarButtonSubscription is a subscription class for `UIBarButtonItem` which is used by `UIBarButtonPublisher` to deliver events.
@available(iOS 13.0, *)
final class UIBarButtonSubscription<SubscriberType: Subscriber, BarButtonItem: UIBarButtonItem>: Subscription where SubscriberType.Input == BarButtonItem {
    // swiftlint:enable line_length
    /// The subscriber associated with the subscription.
    private var subscriber: SubscriberType?

    /// The `UIBarButtonItem` associated with the subscription.
    private weak var barButtonItem: BarButtonItem?

    /// Initializes a new instance of `UIBarButtonSubscription` with a subscriber and `UIBarButtonItem`.
    /// 
    /// - Parameter subscriber: The subscriber to receive the events from `UIBarButtonItem`.
    /// - Parameter barButtonItem: The `UIBarButtonItem` to observe for events.
    init(subscriber: SubscriberType, barButtonItem: BarButtonItem?) {
        self.subscriber = subscriber
        self.barButtonItem = barButtonItem

        // Adds target to UIButton if `barButtonItem`'s customView is a UIButton, otherwise sets the target for `barButtonItem`.
        if let button = barButtonItem?.customView as? UIButton {
            button.addTarget(self, action: #selector(eventHandler), for: .touchUpInside)
        } else {
            barButtonItem?.action = #selector(eventHandler)
            barButtonItem?.target = self
        }
    }

    /// Request an unlimited number of values.
    public func request(_ demand: Subscribers.Demand) {

    }

    /// Cancels the subscription, preventing future values from being sent.
    public func cancel() {
        subscriber = nil
    }

    /// The selector to be called when `UIBarButtonItem` is tapped.
    @objc private func eventHandler() {
        guard let barButtonItem = barButtonItem else { return }
        _ = subscriber?.receive(barButtonItem)
    }
}
