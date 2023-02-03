//
//  Publishers.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Combine
import GRCompatible

@available(iOS 13.0, *)
public extension Publisher where Self: GRCompatible {}

@available(iOS 13.0, *)
public extension GRActive where Base: Publisher {

    ///Combines two publishers to create a 2 member tupple type publisher result type
    func combineWith<Output2: AnyObject>(_ value: Output2) -> AnyPublisher<(Base.Output, Output2), Base.Failure> {
        base.compactMap { [weak value] currentValue in
            guard let value = value else { return nil }
            return (currentValue, value)
        }.eraseToAnyPublisher()
    }

    /// Combines two publishers to create a 3 member tupple type publisher result type
    func combineWith<Output2: AnyObject, Output3: AnyObject>(
        _ value: Output2,
        _ value2: Output3
    ) -> AnyPublisher<(Base.Output, Output2, Output3), Base.Failure> {
        base.compactMap { [weak value, weak value2] currentValue in
            guard let value = value, let value2 = value2 else { return nil }
            return (currentValue, value, value2)
        }.eraseToAnyPublisher()
    }

}

@available(iOS 13.0, *)
public extension Publisher where Failure == Never {

    /// Sink substitution. Where you also assign value to keypath on root object specified
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
       sink { [weak root] in
            root?[keyPath: keyPath] = $0
       }
    }

}
