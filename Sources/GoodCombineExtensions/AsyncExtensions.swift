//
//  AsyncExtensions.swift
//  
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
public func runAsync<T>(_ functions: ThrowingSendableSupplier<T>...) async throws {
    try await withThrowingTaskGroup(of: T.self, body: { group in
        for function in functions {
            group.addTask(operation: function)
        }

        try await group.waitForAll()
    })
}

/// Use when expected error type is different from actual error type.
/// ```
/// enum AppError: Error {
///
///     case serverError
///
/// }
///
/// func sendRequest() async throws -> Int {
///     throw AppError.serverError
///     return 1
/// }
///
/// Task {
///     do {
///         let response = try await sendRequest()
///         print(response)
///     } catch let error as AppError {
///         print(error)
///     } catch {
///         GENERIC_CONTRACT_VIOLATION()
///     }
/// }
/// ```
public func GENERIC_CONTRACT_VIOLATION() -> Never {
    preconditionFailure("Generic contract violated: throwable type does not match Failure type")
}

// MARK: - Publisher -> Async

public extension Publisher where Failure == Never {

    /// Transforms a **never failing** publisher into an async function.
    /// ```
    /// let myPublisher = Just(1).eraseToAnyPublisher()
    /// Task {
    ///     let response = await myPublisher.async()
    ///     print(response)
    /// }
    /// ```
    func async() async -> Output {
        var cancellable: AnyCancellable?
        defer { cancellable = withExtendedLifetime(cancellable, { nil }) }

        return await withCheckedContinuation { continuation in
            cancellable = first().sink { value in
                continuation.resume(returning: value)
            }
        }
    }

}

public extension Publisher {

    /// Transforms a **failing** publisher into an **throwing** async function.
    /// ```
    /// let myPublisher = Just(1)
    ///     .setFailureType(to: Error.self)
    ///     .eraseToAnyPublisher()
    ///
    /// Task {
    ///     let response = try await myPublisher.async()
    ///     print(response)
    /// }
    /// ```
    func async() async throws -> Output {
        var cancellable: AnyCancellable?
        defer { cancellable = withExtendedLifetime(cancellable, { nil }) }

        return try await withCheckedThrowingContinuation { continuation in
            var finished = false
            cancellable = first().sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        guard !finished else { return }
                        #if canImport(Alamofire)
                        continuation.resume(throwing: AFError.explicitlyCancelled)
                        #else
                        continuation.resume(throwing: ExplicitlyCancelledError())
                        #endif

                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                },
                receiveValue: { value in
                    finished = true
                    continuation.resume(returning: value)
                }
            )
        }
    }

}

#if canImport(Alamofire)
import Alamofire

public extension Publisher where Output == Alamofire.Empty {

    func async() async throws {
        let _: Output = try await self.async()
    }

}
#endif

// MARK: - Async -> Publisher

public extension Future where Failure == Never {

    /// Transforms an **non throwing** async function into a **never failing** Future.
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

    /// Transforms an **throwing** async function into a **failing** Future.
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

