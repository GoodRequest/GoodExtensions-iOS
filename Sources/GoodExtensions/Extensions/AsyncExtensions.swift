//
//  AsyncExtensions.swift
//  GoodAsyncExtensions
//
//  Created by Matus Klasovity on 22/09/2023.
//

import Combine
import Foundation

#if swift(>=6)
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
public func runAsync<T: Sendable>(_ functions: (@Sendable () async throws -> (T))...) async throws {
    try await withThrowingTaskGroup(of: T.self, body: { group in
        for function in functions {
            group.addTask(operation: function)
        }

        try await group.waitForAll()
    })
}

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
    var result: Result<T, Error>?
    Task.detached {
        defer { semaphore.signal() }
        do {
            result = .success(try await asyncFunction())
        } catch let error {
            result = .failure(error)
        }
    }
    semaphore.wait()
    
    switch result {
    case .success(let value):
        return value
    case .failure(let failure):
        throw failure
    case nil:
        preconditionFailure("Async function did not return")
    }
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
    Task.detached {
        defer { semaphore.signal() }
        result = await asyncFunction()
    }
    semaphore.wait()

    guard let result else { preconditionFailure("Async function did not return") }
    return result
}
#endif

