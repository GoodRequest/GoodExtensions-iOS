//
//  AsyncExtensions.swift
//  GoodAsyncExtensions
//
//  Created by Matus Klasovity on 22/09/2023.
//

import Combine
import Foundation

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
        } catch {
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

// MARK: - Calling asynchronous APIs synchronously

/// Calls an asynchronous function synchronously, waiting for the result and blocking the caller.
///
/// - warning: This is unsafe, as the function uses a traditional, blocking, dispatch semaphore to wait for the result.
/// - Parameter asyncFunction: asynchronous function to call
/// - Throws: error thrown from async function
/// - Returns: return value of async function
@available(*, deprecated, message: "Heads up: this is unsafe!")
public func unsafeBlockingSync<T: Sendable>(_ asyncFunction: sending @escaping () async throws -> T) throws -> T {
    let semaphore = DispatchSemaphore(value: 0)
    var result: T?
    var failure: (any Error)?
    Task {
        defer { semaphore.signal() }
        do {
            result = try await asyncFunction()
        } catch let error {
            failure = error
        }
    }
    semaphore.wait()

    guard let result else { throw failure ?? preconditionFailure("Async function did not return") }
    return result
}

/// Calls an asynchronous function synchronously, waiting for the result and blocking the caller.
///
/// - warning: This is unsafe, as the function uses a traditional, blocking, dispatch semaphore to wait for the result.
/// - Parameter asyncFunction: asynchronous function to call
/// - Returns: return value of async function
@available(*, deprecated, message: "Heads up: this is unsafe!")
public func unsafeBlockingSync<T: Sendable>(_ asyncFunction: sending @escaping () async -> T) -> T {
    let semaphore = DispatchSemaphore(value: 0)
    var result: T?
    Task {
        defer { semaphore.signal() }
        result = await asyncFunction()
    }
    semaphore.wait()

    guard let result else { preconditionFailure("Async function did not return") }
    return result
}

// MARK: - Future extensions - Swift 5 only

#if swift(<6)
public func GENERIC_CONTRACT_VIOLATION() -> Never {
    preconditionFailure("Generic contract violated: throwable type does not match Failure type")
}

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
    convenience init(_ asyncFunction: @escaping () async -> Output) {
        self.init { (promise: @escaping (Result<Output, Never>) -> Void) in
            Task { promise(.success(await asyncFunction())) }
        }
    }

}

public extension Future {

    /// Transforms a **throwing** async function into a **failing** Future.
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
    convenience init(_ asyncFunction: @escaping () async throws -> Output) {
        self.init { (promise: @escaping (Result<Output, Failure>) -> Void) in
            Task {
                do {
                    promise(.success(try await asyncFunction()))
                } catch let error as Failure {
                    promise(.failure(error))
                } catch {
                    GENERIC_CONTRACT_VIOLATION()
                }
            }
        }
    }

}
#endif
