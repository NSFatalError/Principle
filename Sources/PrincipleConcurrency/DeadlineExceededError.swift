//
//  DeadlineExceededError.swift
//  Principle
//
//  Created by Kamil Strzelecki on 01/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

/// An error that indicates a task has exceeded the deadline.
///
/// This error is thrown by ``withDeadline(until:tolerance:priority:isolation:operation:)`` function.
///
public struct DeadlineExceededError: Error, Equatable {}

public func withDeadline<C: Clock, Success: Sendable>(
    until deadline: C.Instant,
    tolerance: C.Instant.Duration? = nil,
    clock: C,
    priority: TaskPriority? = nil,
    isolation: isolated (any Actor)? = #isolation,
    @_inheritActorContext @_implicitSelfCapture operation: sending @escaping @isolated(any) () async throws -> Success
) async throws -> Success {
    try await withTimeLimit(
        throwing: DeadlineExceededError(),
        after: deadline,
        tolerance: tolerance,
        clock: clock,
        priority: priority,
        isolation: isolation,
        operation: operation
    )
}

public func withDeadline<Success: Sendable>(
    until deadline: ContinuousClock.Instant,
    tolerance: Duration? = nil,
    priority: TaskPriority? = nil,
    isolation: isolated (any Actor)? = #isolation,
    @_inheritActorContext @_implicitSelfCapture operation: sending @escaping @isolated(any) () async throws -> Success
) async throws -> Success {
    try await withDeadline(
        until: deadline,
        tolerance: tolerance,
        clock: .continuous,
        priority: priority,
        isolation: isolation,
        operation: operation
    )
}
