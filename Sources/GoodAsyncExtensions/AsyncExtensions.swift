//
//  AsyncExtensions.swift
//  GoodAsyncExtensions
//
//  Created by Matus Klasovity on 22/09/2023.
//

import Combine

// MARK: - Errors

public struct ExplicitlyCancelledError: Error {
    
    let message = "Explicitly cancelled"

}

// MARK: - Typealiases

public typealias ThrowingSendableSupplier<T> = (@Sendable () async throws -> (T))

// MARK: - Parallel async operations

/// Runs multiple async functions in parallel and waits for all of them to finish.
/// ```
/// let firstRequest: ThrowingSendableSupplier = { [self] in
///     try await firstAsyncRequest()
/// }
/// let secondRequest: ThrowingSendableSupplier = { [self] in
///     try await secondAsyncRequest()
/// }
///
/// try await runAsync(firstRequest, secondRequest)
/// ```
/// - Parameters:
///     - functions: Array of async functions to run in parallel
public func runAsync<T: Sendable>(_ functions: ThrowingSendableSupplier<T>...) async throws {
    try await withThrowingTaskGroup(of: T.self, body: { group in
        for function in functions {
            group.addTask(operation: function)
        }

        try await group.waitForAll()
    })
}

// MARK: - Publisher -> Async

@available(iOS 15.0, *)
public extension Publisher where Failure == Never {

    /// Transforms a **never failing** single-element publisher into an async function.
    ///
    /// In case the publisher finishes without publishing any values, this function will throw
    /// `ExplicitlyCancelledError`.
    /// ```swift
    /// let myPublisher = Just(1).eraseToAnyPublisher()
    /// Task {
    ///     do {
    ///         let response = try await myPublisher.async()
    ///         print(response)
    ///     } catch {
    ///         // handle publisher finishing without value
    ///     }
    /// }
    /// ```
    func async() async throws(ExplicitlyCancelledError) -> Output {
        for await value in values {
            return value
        }
        throw ExplicitlyCancelledError()
    }
    
    /// Transforms a **never failing** single-element publisher into an async function.
    ///
    /// - warning: In case the publisher finishes without publishing any values, this function will trap.
    ///
    /// Usage:
    /// ```swift
    /// let myPublisher = Just(1).eraseToAnyPublisher()
    /// Task {
    ///     let response = await myPublisher.asyncUnsafe()
    ///     print(response)
    /// }
    /// ```
    func asyncUnsafe() async -> Output {
        for await value in values {
            return value
        }
        preconditionFailure("Awaited publisher finished without sending any value.")
    }

}

@available(iOS 15.0, *)
public extension Publisher {

    /// Transforms a **failable** single-element publisher into an **throwing** async function.
    ///
    /// - warning: In case the publisher finishes without publishing any values, this function will trap.
    ///
    /// Usage:
    /// ```swift
    /// let myPublisher = Just(1)
    ///     .setFailureType(to: Error.self)
    ///     .eraseToAnyPublisher()
    ///
    /// Task {
    ///     do {
    ///         let response = try await myPublisher.async()
    ///         print(response)
    ///     } catch {
    ///         // handle any possible error
    ///     }
    /// }
    /// ```
    @available(*, deprecated, renamed: "asyncThrowingFailureUnsafe()", message: "Generic contract is not enforced anymore.")
    func async() async throws -> Output {
        try await asyncThrowingAny()
    }
    
    /// Transforms a **failable** single-element publisher into an **throwing** async function.
    ///
    /// Usage:
    /// ```swift
    /// let myPublisher = Just(1)
    ///     .setFailureType(to: Error.self)
    ///     .eraseToAnyPublisher()
    ///
    /// Task {
    ///     do {
    ///         let response = try await myPublisher.asyncThrowingAny()
    ///         print(response)
    ///     } catch {
    ///         // handle any possible error
    ///     }
    /// }
    /// ```
    func asyncThrowingAny() async throws -> Output {
        var cancellable: AnyCancellable?
        defer { cancellable = withExtendedLifetime(cancellable, { nil }) }

        do {
            for try await value in values {
                return value
            }
        } catch let error {
            throw error
        }
        throw ExplicitlyCancelledError()
    }

    /// Transforms a **failable** single-element publisher into a **throwing** async function.
    ///
    /// - warning: In case the publisher finishes without publishing any values, this function will trap.
    ///
    /// Usage:
    /// ```swift
    /// let myPublisher = Just(1)
    ///     .setFailureType(to: Error.self)
    ///     .eraseToAnyPublisher()
    ///
    /// Task {
    ///     do {
    ///         let response = try await myPublisher.asyncThrowingAny()
    ///         print(response)
    ///     } catch {
    ///         // handle error of Failure type
    ///     }
    /// }
    /// ```
    func asyncThrowingFailureUnsafe() async throws(Failure) -> Output {
        var cancellable: AnyCancellable?
        defer { cancellable = withExtendedLifetime(cancellable, { nil }) }

        do {
            for try await value in values {
                return value
            }
        } catch let error as Failure {
            throw error
        } catch let error {
            preconditionFailure("Generic contract breached by Combine - throwing undeclared error.")
        }
        preconditionFailure("Awaited publisher finished without sending any value.")
    }

}

#if canImport(Alamofire)
import Alamofire

@available(iOS 15.0, *)
public extension Publisher where Output == Alamofire.Empty {

    @available(*, deprecated, message: "Generic contract is not enforced anymore.")
    func async() async throws {
        let _: Output = try await self.async()
    }

}
#endif

// MARK: - Async -> Publisher

@available(*, deprecated, message: "This is unsafe, migrate to Swift Concurrency")
public extension Future where Failure == Never {

    /// Transforms a **non throwing** async function into a **never failing** Future.
    /// ```
    /// func myAsyncFunction() async -> Int {
    ///    await Task.sleep(1_000_000_000)
    ///    return 1
    /// }
    /// let future = Future {
    ///     await myAsyncFunction()
    /// }
    /// ```
    /// - Parameters:
    ///     - asyncFunction: **non throwing** Async function to run
    convenience init(_ asyncFunction: @Sendable @escaping () async -> Output) {
        self.init { (promise: @escaping (Result<Output, Never>) -> Void) in
            nonisolated(unsafe) let promise = promise
            Task { promise(.success(await asyncFunction())) }
        }
    }

}

@available(*, deprecated, message: "This is unsafe, migrate to Swift Concurrency")
public extension Future {

    /// Transforms a **throwing** async function into a **failable** Future.
    /// ```
    /// func myThrowingAsyncFunction() async throws -> Int {
    ///    await Task.sleep(1_000_000_000)
    ///    return 1
    /// }
    /// let future = Future {
    ///     await myThrowingAsyncFunction()
    /// }
    /// ```
    /// - Parameters:
    ///     - asyncFunction: **throwing** Async function to run
    convenience init(_ asyncFunction: @Sendable @escaping () async throws(Failure) -> Output) {
        self.init { (promise: @escaping (Result<Output, Failure>) -> Void) in
            nonisolated(unsafe) let promise = promise
            Task {
                do {
                    promise(.success(try await asyncFunction()))
                } catch let error as Failure {
                    promise(.failure(error))
                }
            }
        }
    }

}
