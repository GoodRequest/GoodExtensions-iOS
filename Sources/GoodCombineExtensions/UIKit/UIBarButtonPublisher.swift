//
//  UIBarButtonPublisher.swift
//  GoodCombineExtensions
//
//  Created by GoodRequest on 26/08/2021.
//

import UIKit
import Combine
import GRCompatible

@available(iOS 13.0, *)
public struct UIBarButtonPublisher<BarButtonItem: UIBarButtonItem>: Publisher {

    /// The type of output generated by this publisher.
    public typealias Output = BarButtonItem

    /// The type of failure that can occur on this publisher.
    public typealias Failure = Never

    /// The `UIBarButtonItem` instance that generates events.
    weak var barButtonItem: BarButtonItem?

    /// Creates a `UIBarButtonPublisher` instance.
    ///
    /// - Parameter barButtonItem: The `UIBarButtonItem` instance that generates events.
    /// - Parameter event: The `UIControl.Event` that triggers the publisher.
    init(barButtonItem: BarButtonItem, event: UIControl.Event) {
        self.barButtonItem = barButtonItem
    }

    /// This function is called to attach the specified subscriber to this publisher.
    ///
    /// - Parameter subscriber: The subscriber to attach to this publisher.
    public func receive<S>(subscriber: S) where S: Subscriber,
                                         S.Failure == UIBarButtonPublisher.Failure,
                                         S.Input == UIBarButtonPublisher.Output {
        let subscription = UIBarButtonSubscription(
            subscriber: subscriber,
            barButtonItem: barButtonItem
        )
        subscriber.receive(subscription: subscription)
    }
}

@available(iOS 13.0, *)
public extension GRActive where Base: UIBarButtonItem {

    /// Returns a publisher that emits events when the button item is tapped.
    ///
    /// - Parameter event: The `UIControl.Event` that triggers the publisher.
    func tapPublisher(for event: UIControl.Event) -> UIBarButtonPublisher<UIBarButtonItem> {
        UIBarButtonPublisher(barButtonItem: base, event: event)
    }

}
