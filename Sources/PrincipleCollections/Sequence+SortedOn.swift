//
//  Sequence+SortedOn.swift
//  Principle
//
//  Created by Kamil Strzelecki on 15/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

extension Sequence {

    /// Returns the elements of the sequence, sorted using the given projection and comparison function.
    ///
    /// - Parameters:
    ///   - projection: A closure that retrieves values from the `Element` which will be compared.
    ///   - areInIncreasingOrder: A predicate that returns true if its first argument should be ordered before its second argument; otherwise, false.
    /// - Returns: A sorted array of the sequence’s elements.
    ///
    /// Many types don’t naturally conform to `Comparable`, but they contain properties that can be used for ordering.
    /// Use this function to sort such types.
    ///
    /// ### Usage
    /// ```swift
    /// people.sorted(on: \.name, by: >)
    /// ```
    ///
    public func sorted<T>(
        on projection: (Element) throws -> T,
        by areInIncreasingOrder: (T, T) throws -> Bool
    ) rethrows -> [Element] {
        try sorted { lhs, rhs in
            try areInIncreasingOrder(projection(lhs), projection(rhs))
        }
    }

    /// Returns the elements of the sequence, sorted using the given projection.
    ///
    /// - Parameter projection: A closure that retrieves `Comparable` values from the `Element`.
    /// - Returns: A sorted array of the sequence’s elements in ascending order.
    ///
    /// Many types don’t naturally conform to `Comparable`, but they contain properties that can be used for ordering.
    /// Use this function to sort such types.
    ///
    /// ### Usage
    /// ```swift
    /// people.sorted(on: \.name)
    /// ```
    ///
    public func sorted(
        on projection: (Element) throws -> some Comparable
    ) rethrows -> [Element] {
        try sorted(on: projection, by: <)
    }
}

extension MutableCollection where Self: RandomAccessCollection {

    /// Sorts the collection in place using the given projection and comparison function.
    ///
    /// - Parameters:
    ///   - projection: A closure that retrieves values from the `Element` which will be compared.
    ///   - areInIncreasingOrder: A predicate that returns true if its first argument should be ordered before its second argument; otherwise, false.
    ///
    /// Many types don’t naturally conform to `Comparable`, but they contain properties that can be used for ordering.
    /// Use this function to sort such types.
    ///
    /// ### Usage
    /// ```swift
    /// people.sort(on: \.name, by: >)
    /// ```
    ///
    public mutating func sort<T>(
        on projection: (Element) throws -> T,
        by areInIncreasingOrder: (T, T) throws -> Bool
    ) rethrows {
        try sort { lhs, rhs in
            try areInIncreasingOrder(projection(lhs), projection(rhs))
        }
    }

    /// Sorts the collection in place using the given projection.
    ///
    /// - Parameter projection: A closure that retrieves `Comparable` values from the `Element`.
    ///
    /// Many types don’t naturally conform to `Comparable`, but they contain properties that can be used for ordering.
    /// Use this function to sort such types.
    ///
    /// ### Usage
    /// ```swift
    /// people.sort(on: \.name)
    /// ```
    ///
    public mutating func sort(
        on projection: (Element) throws -> some Comparable
    ) rethrows {
        try sort(on: projection, by: <)
    }
}
