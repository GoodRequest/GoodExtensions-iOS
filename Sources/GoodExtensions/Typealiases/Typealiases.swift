//
//  Typealiases.swift
//  GoodExtensions-iOS
//
//  Created by Filip Šašala on 24/06/2024.
//

import SwiftUI

// MARK: - SwiftUI

@available(*, deprecated, message: "Check correct usage of ObservedObject!")
public typealias ObservedObject = UnsafeObservedObject
public typealias UnsafeObservedObject = SwiftUI.ObservedObject

// MARK: - Closures

public typealias VoidClosure = () -> ()
public typealias Supplier<T> = () -> (T)
public typealias Consumer<T> = (T) -> ()
public typealias BiConsumer<T, U> = (T, U) -> ()
public typealias Predicate<T> = (T) -> Bool
public typealias Function<T, U> = (T) -> (U)
