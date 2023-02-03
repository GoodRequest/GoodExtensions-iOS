//
//  UITextFieldSubscriber.swift
//  
//
//  Created by Andrej Jasso on 11/03/2022.
//

import Combine
import GRCompatible
import UIKit

// swiftlint:disable line_length
/// The `UITextFieldSubscription` is a custom `Subscription` for handling `UITextField` events and sending those events to a `Subscriber`.
@available(iOS 13.0, *)
final public class UITextFieldSubscription<SubscriberType: Subscriber, TextField: UITextField>: Subscription where SubscriberType.Input == TextField {
// swiftlint:enable line_length

    private var subscriber: SubscriberType?
    private weak var textfield: TextField?

    /// Initialize a new `UITextFieldSubscription` with a subscriber, `UITextField`, and a `UIControl.Event` to observe.
    ///
    /// - Parameters:
    ///   - subscriber: The subscriber to receive events from the `UITextField`.
    ///   - textfield: The `UITextField` to observe for events.
    ///   - event: The `UIControl.Event` to observe on the `UITextField`.
    init(subscriber: SubscriberType, textfield: TextField?, event: UITextField.Event) {
        self.subscriber = subscriber
        self.textfield = textfield

        textfield?.addTarget(self, action: #selector(eventHandler), for: event)
    }

    public func request(_ demand: Subscribers.Demand) {}

    /// Cancel the subscription, releasing the subscriber and removing the target from the UITextField.
    public func cancel() {
        subscriber = nil
    }

    /// The event handler that is called when the UITextField sends the specified event.
    /// The UITextField is sent to the subscriber.
    @objc private func eventHandler() {
        guard let textfield = textfield else { return }
        _ = subscriber?.receive(textfield)
    }
}

public extension GRActive where Base: UITextField {

    /// Creates a `UITextFieldPublisher` for the specified `UIControl.Event` on the `UITextField`.
    ///
    /// - Parameter event: The `UIControl.Event` to observe on the `UITextField`.
    /// - Returns: A `UITextFieldPublisher` that sends the `UITextField` as the event.
    func eventPublisher(for event: UIControl.Event) -> UITextFieldPublisher<UITextField> {
        UITextFieldPublisher(control: base, event: event)
    }

}

public extension GRActive where Base: UITextField {

    // An `AnyPublisher` that emits the text of a `UITextField` whenever it changes.
    var textPublisher: AnyPublisher<String?, Never> {
        Publishers.ControlProperty(control: base, events: [.valueChanged, .allEditingEvents], keyPath: \.text)
            .eraseToAnyPublisher()
    }

}
