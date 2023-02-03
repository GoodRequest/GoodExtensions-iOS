//
//  Array.swift
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2019 GoodRequest. All rights reserved.
//

import Foundation
import GRCompatible

extension Collection where Self: GRCompatible { }

public extension GRActive where Base: Collection {

    /// Returns array of elements where between each element will be inserted element, provided in parameter.
    /// - Parameter element: The element to insert
    /// - Returns: Returns array of elements separated by given element
    func separated(by element: Base.Element) -> [Base.Element] {
        return Array(base.map { [$0] }.joined(separator: [element]))
    }

    /// Checks if array constains item with given index.
    /// - Parameter index: The index of element in array
    /// - Returns: Boolean result whether array containts item with specified index or not.
    func contains(index: Int) -> Bool {
        // swiftlint:disable force_cast
        return (base.startIndex..<base.endIndex).contains(index as! Base.Index)
        // swiftlint:enable force_cast
    }

    /// True if array contains elements, otherwise false
    var hasItems: Bool { !base.isEmpty }

}

public extension GRActive where Base: Collection {

    /// The function modifies the base array by either removing the object if it exists in the array, or appending it if it does not. The function returns the modified base array.
    ///
    /// - Parameter object: Object to remove or append
    /// - Returns: The function returns the modified base array.
    func removingOrAppending<Element: Equatable>(object: Element) -> Base where Base == [Element] {
        var muttableBase = base
        muttableBase.removeOrAppend(object: object)
        return muttableBase
    }

    /// This function is an extension of an array of optional strings and returns a string after joining the non-nil values from the array.
    ///
    /// - Parameter separator: A string value that is used as a separator between the non-nil elements of the array. The default value is an empty string.
    /// - Returns: String after joining the non-nil values from the array.
    func joinNonNil(separator: String = "") -> String where Base == [String?] {
        return base.compactMap { $0 }.joined(separator: separator)
    }

    /// This function takes an array of Element elements and chunks it into an array of arrays with a specified size.
    ///
    /// - Parameter size: The size of each chunk.
    /// - Returns: An array of arrays with the chunked elements.
    func chunked<Element: Strideable>(into size: Int) -> [[Element]] where Base == [Element] {
        return base.chunked(into: size)
    }

    /// Returns an array of unique elements, preserving the original order.
    ///
    /// - Returns: An array of unique elements from the original array, preserving the original order.
    func removedDuplicates<Element: Equatable>() -> [Element] where Base == [Element] {
        var muttableArray = base
        let filteredArray = muttableArray.removeDuplicates()
        return filteredArray
    }

    /// Prepends a new element to the current array and returns the modified array
    ///
    /// - Parameter newElement: The element to be added to the beginning of the array
    /// - Returns: An array with the new element added to the beginning
    func prepending<Element: Equatable>(_ newElement: Element) -> [Element] where Base == [Element] {
        var muttableArray = base
        muttableArray.insert(newElement, at: 0)
        return muttableArray
    }

    /// Swaps two elements in an array and returns the modified array.
    ///
    /// - Parameters:
    ///   - startIndex: The index of the first element to swap.
    ///   - endIndex: The index of the second element to swap.
    /// - Returns: A new array with the two elements swapped.
    func swapped<Element: Equatable>(from startIndex: Base.Index, to endIndex: Base.Index) -> [Element] where Base == [Element] {
        var muttableArray = base
        muttableArray.swap(from: startIndex, to: endIndex)
        return muttableArray
    }

}

extension Array: GRCompatible {}

public extension Array {

    /**
     Checks for item at index safely.
     - returns: If failed returns nil.
    */
    subscript(safe index: Int) -> Element? {
        self.gr.contains(index: index) ? self[index] : nil
    }

    @available(*, deprecated, message: "This should not be called couse it's muttable and will be private in future versions.")
    mutating func removeOrAppend(object: Element) where Element: Equatable {
        if self.contains(object) {
            removeAll(where: { $0 == object })
        } else {
            append(object)
        }
    }

    @available(*, deprecated, message: "This should not be called couse it's muttable and will be private in future versions.")
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    /// SwifterSwift: Remove all duplicate elements from Array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeDuplicates() -> [1, 2, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"]. removeDuplicates() -> ["h", "e", "l", "o"]
    ///
    /// - Returns: Return array with all duplicate elements removed.
    @discardableResult
    @available(*, deprecated, message: "This should not be called couse it's muttable and will be private in future versions.")
    mutating func removeDuplicates() -> [Element] where Element: Equatable {
        // Thanks to https://github.com/sairamkotha for improving the method
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
        return self
    }

    /// https://github.com/SwifterSwift/SwifterSwift/blob/master

    /// SwifterSwift: Insert an element at the beginning of array.
    ///
    ///        [2, 3, 4, 5].prepend(1) -> [1, 2, 3, 4, 5]
    ///        ["e", "l", "l", "o"].prepend("h") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement: element to insert.
    @available(*, deprecated, message: "This should not be called couse it's muttable and will be private in future versions.")
    mutating func prepend(_ newElement: Element) where Element: Equatable {
        insert(newElement, at: 0)
    }

    /// SwifterSwift: Safely swap values at given index positions.
    ///
    ///        [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///        ["h", "e", "l", "l", "o"].safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: index of first element.
    ///   - otherIndex: index of other element.
    @available(*, deprecated, message: "This should not be called couse it's muttable and will be private in future versions.")
    mutating func swap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }

}
