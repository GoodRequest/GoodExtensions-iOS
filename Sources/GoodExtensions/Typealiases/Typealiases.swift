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
// MARK: Regular (Swift 6 Sendable)

public typealias VoidClosure = @Sendable () -> ()
public typealias Supplier<T> = @Sendable () -> (T)
public typealias Consumer<T> = @Sendable (T) -> ()
public typealias BiConsumer<T, U> = @Sendable (T, U) -> ()
public typealias Predicate<T> = @Sendable (T) -> Bool
public typealias Function<T, U> = @Sendable (T) -> (U)

// MARK: Non-sendable

public typealias NonSendableVoidClosure = () -> ()
public typealias NonSendableSupplier<T> = () -> (T)
public typealias NonSendableConsumer<T> = (T) -> ()
public typealias NonSendableBiConsumer<T, U> = (T, U) -> ()
public typealias NonSendablePredicate<T> = (T) -> Bool
public typealias NonSendableFunction<T, U> = (T) -> (U)

// MARK: Throwing

public typealias ThrowingVoidClosure<E> = @Sendable () throws(E) -> ()
public typealias ThrowingSupplier<T, E> = @Sendable () throws(E) -> (T)
public typealias ThrowingConsumer<T, E> = @Sendable (T) throws(E) -> ()
public typealias ThrowingBiConsumer<T, U, E> = @Sendable (T, U) throws(E) -> ()
public typealias ThrowingPredicate<T, E> = @Sendable (T) throws(E) -> Bool
public typealias ThrowingFunction<T, U, E> = @Sendable (T) throws(E) -> (U)

// MARK: MainActor

public typealias MainClosure = @MainActor () -> ()
public typealias MainSupplier<T> = @MainActor () -> (T)
public typealias MainConsumer<T> = @MainActor (T) -> ()
public typealias MainBiConsumer<T, U> = @MainActor (T, U) -> ()
public typealias MainPredicate<T> = @MainActor (T) -> Bool
public typealias MainFunction<T, U> = @MainActor (T) -> (U)

// MARK: MainActor + Throwing

public typealias MainThrowingVoidClosure<E> = @MainActor () throws(E) -> ()
public typealias MainThrowingSupplier<T, E> = @MainActor () throws(E) -> (T)
public typealias MainThrowingConsumer<T, E> = @MainActor (T) throws(E) -> ()
public typealias MainThrowingBiConsumer<T, U, E> = @MainActor (T, U) throws(E) -> ()
public typealias MainThrowingPredicate<T, E> = @MainActor (T) throws(E) -> Bool
public typealias MainThrowingFunction<T, U, E> = @MainActor (T) throws(E) -> (U)
