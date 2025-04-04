//
//  TimeoutError.swift
//  Principle
//
//  Created by Kamil Strzelecki on 01/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

/// An error that indicates a task has run longer than the maximum allowed duration.
///
/// This error is thrown by ``withTimeout(_:tolerance:priority:isolation:operation:)`` function.
///
public struct TimeoutError: Error, Equatable {}

public func withTimeout<C: Clock, Success: Sendable>(
    _ duration: C.Instant.Duration,
    tolerance: C.Instant.Duration? = nil,
    clock: C,
    priority: TaskPriority? = nil,
    isolation: isolated (any Actor)? = #isolation,
    @_inheritActorContext @_implicitSelfCapture operation: sending @escaping @isolated(any) () async throws -> Success
) async throws -> Success {
    try await withTimeLimit(
        throwing: TimeoutError(),
        after: clock.now.advanced(by: duration),
        tolerance: tolerance,
        clock: clock,
        priority: priority,
        isolation: isolation,
        operation: operation
    )
}

public func withTimeout<Success: Sendable>(
    _ duration: Duration,
    tolerance: Duration? = nil,
    priority: TaskPriority? = nil,
    isolation: isolated (any Actor)? = #isolation,
    @_inheritActorContext @_implicitSelfCapture operation: sending @escaping @isolated(any) () async throws -> Success
) async throws -> Success {
    try await withTimeout(
        duration,
        tolerance: tolerance,
        clock: .continuous,
        priority: priority,
        isolation: isolation,
        operation: operation
    )
}
