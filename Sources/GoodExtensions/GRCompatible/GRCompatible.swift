//
//  GRCompatible.swift
//  
//
//  Created by Dominik Pethö on 4/30/19.
//

import Foundation

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public struct GRActive<Base> {

    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }

}

/// A type that has reactive extensions.
@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public protocol GRCompatible {

    /// Extended type
    associatedtype GRActiveBase

    /// GRActive extensions.
    static var gr: GRActive<GRActiveBase>.Type { get set }

    /// GRActive extensions.
    var gr: GRActive<GRActiveBase> { get set }
    
}

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public extension GRCompatible {

    /// Reactive extensions.
    static var gr: GRActive<Self>.Type {
        get {
            return GRActive<Self>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base type
        }
    }

    /// Reactive extensions.
    var gr: GRActive<Self> {
        get {
            return GRActive(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using GRActive to "mutate" base object
        }
    }

}

/// Extend NSObject with `gr` proxy.
@available(*, deprecated, message: "This extension is deprecated and marked for removal")
extension NSObject: GRCompatible { }
