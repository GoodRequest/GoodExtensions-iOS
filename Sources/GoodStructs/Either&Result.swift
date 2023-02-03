//
//  Either&Result.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation

// MARK: Either represents a value of one of two possible types (a disjoint union).

/// Instances of Either are either an instance of Left or Right.
/// A common use of Either is as an alternative to Option for dealing with possible missing values,
/// or option to return multiple types from functions.

/// left - container for value of first type
/// right - container for value of second type
public enum Either<L, R> {

    case left(L)
    case right(R)

    /// Returns one value of single type.
    public func either<ReturnValue>(ifLeft: (L) -> ReturnValue, ifRight: (R) -> ReturnValue) -> ReturnValue {
        switch self {
        case let .left(x):
            return ifLeft(x)

        case let .right(x):
            return ifRight(x)
        }
    }

    public func either(ifLeft: (L) -> Void, ifRight: (R) -> Void) {
        switch self {
        case let .left(x):
            ifLeft(x)

        case let .right(x):
            ifRight(x)
        }
    }

    public func map<ReturnValue>(
        _ transform: (R) -> ReturnValue
    ) -> Either<L, ReturnValue> where ReturnValue: Equatable {
        return flatMap { .right(transform($0)) }
    }

    public func map<ReturnValue>(_ transform: (R) -> ReturnValue) -> Either<L, ReturnValue> {
        return flatMap { .right(transform($0)) }
    }

    private func flatMap<RType>(_ transform: (R) -> Either<L, RType>)
    -> Either<L, RType> {
        return either(
            ifLeft: Either<L, RType>.left,
            ifRight: transform
        )
    }

    private func flatMap<RType>(_ transform: (R) -> Either<L, RType>)
    -> Either<L, RType> where RType: Equatable {
        return either(
            ifLeft: Either<L, RType>.left,
            ifRight: transform
        )
    }

    public func mapLeft<LType>(_ transform: (L) -> LType)
    -> Either<LType, R> {
        return flatMapLeft { .left(transform($0)) }
    }

    public func flatMapLeft<LType>(_ transform: (L) -> Either<LType, R>)
    -> Either<LType, R> {
        return either(
            ifLeft: transform,
            ifRight: Either<LType, R>.right
        )
    }

    public func mapToNothing() -> Either<L, Nothing> {
        return either(
            ifLeft: { return Either<L, Nothing>.left($0) },
            ifRight: { _ in return Either<L, Nothing>.right(Nothing()) }
        )
    }

    public func toResult() -> GRResult<R, L> {
        switch self {
        case let .left(error):
            return GRResult.failure(error)

        case let .right(value):
            return GRResult.success(value)
        }
    }

    public func unwrap() throws -> R {
        switch self {
        case .right(let value):
            return value

        default:
            throw EitherResultError.unwrap
        }
    }

    public func unwrapLeft() throws -> L {
        switch self {
        case .left(let value):
            return value

        default:
            throw EitherResultError.unwrap
        }
    }

}

/// Result represents state of task. Loading is mostly used at beginning of task.
/// Success type represents result value when task is finished succesfully.
/// Failure is used for catching errors from tasks. Used for preventing of TRY CATCH usage.
public enum GRResult<V, E> {

    case loading
    case success(V)
    case failure(E)

    public func map<V2>(_ transform: (V) -> V2) -> GRResult<V2, E> {
        switch self {
        case .loading:
            return GRResult<V2, E>.loading

        case let .failure(value):
            return GRResult<V2, E>.failure(value)

        case let .success(value):
            return GRResult<V2, E>.success(transform(value))
        }
    }

    public func mapError<E2>(_ transform: (E) -> E2) -> GRResult<V, E2> {
        switch self {
        case .loading:
            return GRResult<V, E2>.loading

        case let .failure(value):
            return GRResult<V, E2>.failure(transform(value))

        case let .success(value):
            return GRResult<V, E2>.success(value)
        }
    }

    public func flatMap<V2>(_ transform: (V) -> GRResult<V2, E>) -> GRResult<V2, E> {
        switch self {
        case .loading:
            return GRResult<V2, E>.loading

        case let .failure(value):
            return GRResult<V2, E>.failure(value)

        case let .success(value):
            return transform(value)
        }
    }

    public var isSuccess: Bool {
        switch self {
        case .success:
            return true

        default:
            return false
        }
    }

    public var isLoading: Bool {
        switch self {
        case .loading:
            return true

        default:
            return false
        }
    }

    public var isFailure: Bool {
        switch self {
        case .failure:
            return true

        default:
            return false
        }
    }

    public func unwrapSuccess() throws -> V {
        switch self {
        case .success(let value):
            return value

        default:
            throw EitherResultError.unwrap
        }
    }

    public func unwrapFailure() throws -> E {
        switch self {
        case .failure(let value):
            return value

        default:
            throw EitherResultError.unwrap
        }
    }
}

enum EitherResultError: Error {

    case unwrap

}

extension Either: Equatable where L: Equatable, R: Equatable {

    public static func ==<E: Equatable, V: Equatable>(left: Either<E, V>, right: Either<E, V>) -> Bool {
        if case let .right(leftValue) = left, case let  .right(rightValue) = right {
            return leftValue == rightValue
        }

        if case let .left(leftError) = left, case let .left(rightError) = right {
            return leftError == rightError
        }

        return false
    }

}

/// Functions for comparing Result container
extension GRResult: Equatable where E: Equatable, V: Equatable {

    public static func ==<E: Equatable, V: Equatable>(left: GRResult<V, E>, right: GRResult<V, E>) -> Bool {
        if case let .success(leftValue) = left, case let  .success(rightValue) = right {
            return leftValue == rightValue
        }

        if case let .failure(leftError) = left, case let .failure(rightError) = right {
            return leftError == rightError
        }

        if case .loading = left, case .loading = right {
            return true
        }

        return false
    }

}

public func ==<E, V>(left: GRResult<V, E>, right: GRResult<V, E>) -> Bool {
    if case .success(_) = left, case .success(_) = right {
        return true
    }
    if case .failure = left, case .failure = right {
        return true
    }
    if case .loading = left, case .loading = right {
        return false
    }
    return false
}

public func !=<V: Equatable, E: Equatable>(left: GRResult<V, E>, right: GRResult<V, E>) -> Bool {
    return !(left == right)
}

public func !=<E, V>(left: GRResult<V, E>, right: GRResult<V, E>) -> Bool {
    if case .loading = left, case .loading = right {
        return false
    }
    return !(left == right)
}

public func zip<E, R1, R2>(_ leftResult: GRResult<R1, E>, _ rightResult: GRResult<R2, E>) -> GRResult<(R1, R2), E> {
    if case .failure(let e) = leftResult {
        return .failure(e)
    }

    if case .failure(let e) = rightResult {
        return .failure(e)
    }

    if case .success(let valueLeft) = leftResult, case .success(let valueRight) = rightResult {
        return .success((valueLeft, valueRight))
    }

    return .loading
}
