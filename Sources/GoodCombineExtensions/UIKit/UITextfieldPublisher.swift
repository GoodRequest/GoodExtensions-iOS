//
//  UITextFieldPublisher.swift
//  
//
//  Created by Andrej Jasso on 10/03/2022.
//

import Combine
import GRCompatible
import UIKit

/// Represents a publisher for events from a UITextField.
@available(iOS 13.0, *)
public struct UITextFieldPublisher<TextField: UITextField>: Publisher {

    /// Type of the emitted values
    public typealias Output = TextField

    /// Type of failure that the publisher may emit, `Never` in this case
    public typealias Failure = Never

    /// Weak reference to the UITextField that the publisher should observe.
    weak var textfield: TextField?

    /// The UITextField.Event that the publisher should listen for.
    let event: UITextField.Event

    /// Creates an instance of `UITextFieldPublisher`
    /// - Parameters:
    ///   - control: the `UITextField` that the publisher should observe.
    ///   - event: the `UITextField.Event` that the publisher should listen for.
    init(control: TextField, event: UIControl.Event) {
        self.textfield = control
        self.event = event
    }

    /// Creates an instance of UITextFieldSubscription and passes this subscription to the subscriber.
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, TextField == S.Input {
        let subscription = UITextFieldSubscription(
            subscriber: subscriber,
            textfield: textfield,
            event: event
        )
        subscriber.receive(subscription: subscription)
    }

}
