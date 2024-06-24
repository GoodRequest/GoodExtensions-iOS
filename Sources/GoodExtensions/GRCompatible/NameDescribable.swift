//
//  NameDescribable.swift
//  
//
//  Created by Dominik Pethö on 4/30/19.
//

import Foundation

/// Name describable allow your to take typename from any type extending the protocol
@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public protocol NameDescribable {

    /// Typename of NSObject. Useful for example when diffing
    var typeName: String { get }

    /// Typename of NSObject. Useful for example when diffing
    static var typeName: String { get }

}

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public extension NameDescribable {

    /// Typename of NSObject. Useful for example when diffing
    var typeName: String { String(describing: type(of: self)) }

    /// Typename of NSObject. Useful for example when diffing
    static var typeName: String { String(describing: type(of: self)) }

}

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public extension GRActive where Base: NSObject {

    /// Typename of NSObject. Useful for example when diffing
    var typeName: String { String(describing: type(of: base)) }

    /// Typename of NSObject. Useful for example when diffing
    static var typeName: String { String(describing: Base.self) }

}

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public extension GRActive where Base: Collection {

    /// Typename of NSObject. Useful for example when diffing
    var typeName: String { String(describing: type(of: base)) }

    /// Typename of NSObject. Useful for example when diffing
    static var typeName: String { String(describing: Base.self) }

}
