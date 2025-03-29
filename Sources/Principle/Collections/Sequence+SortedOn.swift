//
//  Sequence+SortedOn.swift
//  Principle
//
//  Created by Kamil Strzelecki on 15/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

extension Sequence {

    public func sorted<T>(
        on projection: (Element) throws -> T,
        by areInIncreasingOrder: (T, T) throws -> Bool
    ) rethrows -> [Element] {
        try sorted { lhs, rhs in
            try areInIncreasingOrder(projection(lhs), projection(rhs))
        }
    }

    public func sorted(
        on projection: (Element) throws -> some Comparable
    ) rethrows -> [Element] {
        try sorted(on: projection, by: <)
    }
}

extension MutableCollection where Self: RandomAccessCollection {

    public mutating func sort<T>(
        on projection: (Element) throws -> T,
        by areInIncreasingOrder: (T, T) throws -> Bool
    ) rethrows {
        try sort { lhs, rhs in
            try areInIncreasingOrder(projection(lhs), projection(rhs))
        }
    }

    public mutating func sort(
        on projection: (Element) throws -> some Comparable
    ) rethrows {
        try sort(on: projection, by: <)
    }
}
