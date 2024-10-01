//
//  AsyncExtensions.swift
//  GoodExtensions
//
//  Created by Filip Šašala on 29/09/2024.
//

// MARK: - Future extensions - Swift 5 only

#if swift(<6)
import Combine

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
