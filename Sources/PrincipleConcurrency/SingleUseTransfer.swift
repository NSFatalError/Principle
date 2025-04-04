//
//  SingleUseTransfer.swift
//  Principle
//
//  Created by Kamil Strzelecki on 03/04/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

/// Utility allowing to safely transfer `sending` value into a closure in cases where the programmer
/// can guarantee that it won't be transferred more than once.
///
/// - Warning: Failing to fulfill the requirement to not transfer value more than once will result in a crash.
///
/// Swift does not have a built-in mechanism that would ensure a closure would not be called more than once.
/// This limits what region-based isolation can infer about the execution flow and forces it to be more restrictive than necessary.
///
/// Unlike bypassing strict concurrency checking with any of the unsafe annotations, like `@unchecked` or `nonisolated(unsafe)`,
/// all compile-time guarantees are enforced on `SingleUseTransfer` instances.
///
/// ### Usage
///
/// ```swift
/// let mutex = Mutex(NonSendable())
/// let instance = NonSendable()
/// var transfer = SingleUseTransfer(instance)
/// mutex.withLock { protected in
///     protected = transfer.finalize()
/// }
/// ```
///
public struct SingleUseTransfer<Wrapped: ~Copyable>: ~Copyable {

    private var value: Wrapped?
    
    /// Initializes a new transfer, which the programmer must manually verify will not be mutated more than once.
    ///
    /// - Parameter value: A value the compiler considers unsafe to capture in a closure.
    ///
    public init(_ value: consuming sending Wrapped) {
        self.value = consume value
    }

    private init() {
        self.value = nil
    }

    /// Consumes a transfer captured from an outer closure to pass it to the inner closure.
    ///
    /// - Returns: A new single-use transfer referencing the original value.
    ///
    /// - Warning: After calling this method, the instance must no longer be used. Doing so will result in a crash.
    ///
    /// If you're trying to finalize a transfer in a nested closure use this method as an intermediate step
    /// to satisfy the compiler requirements.
    ///
    /// ### Usage
    ///
    /// ``` swift
    /// let instance = NonSendable()
    /// var transfer = SingleUseTransfer(instance)
    /// await withTaskGroup { group in
    ///     var transfer = transfer.take()
    ///     group.addTask {
    ///         transfer.finalize()
    ///     }
    /// }
    /// ```
    ///
    public mutating func take() -> sending Self {
        .init(finalize())
    }

    /// Consumes a transfer and passes its value to the closure.
    ///
    /// - Returns: A value which was used to initialize the transfer with.
    ///
    /// - Warning: After calling this method, the instance must no longer be used. Doing so will result in a crash.
    ///
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
