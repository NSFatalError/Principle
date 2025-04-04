//
//  SingleUseTransfer.swift
//  Principle
//
//  Created by Kamil Strzelecki on 03/04/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public struct SingleUseTransfer<Wrapped: ~Copyable>: ~Copyable {

    private var value: Wrapped?

    public init(_ value: consuming sending Wrapped) {
        self.value = consume value
    }

    private init() {
        self.value = nil
    }

    public mutating func take() -> sending Self {
        .init(finalize())
    }

    public mutating func finalize() -> sending Wrapped {
        switch consume value {
        case .none:
            preconditionFailure("Attempted to transfer value more than once.")
        case let .some(wrapped):
            self = .init()
            return wrapped
        }
    }
}
