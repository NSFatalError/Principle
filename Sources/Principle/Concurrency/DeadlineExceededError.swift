//
//  DeadlineExceededError.swift
//  Principle
//
//  Created by Kamil Strzelecki on 01/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public struct DeadlineExceededError: Error {}

public func withDeadline<C: Clock, Success: Sendable>(
    until deadline: C.Instant,
    tolerance: C.Instant.Duration? = nil,
    clock: C,
    isolation: isolated (any Actor)? = #isolation,
    priority: TaskPriority? = nil,
    @_inheritActorContext @_implicitSelfCapture operation: sending @escaping @isolated(any) () async throws -> Success
) async throws -> Success {
    try await withTimeLimit(
        throwing: DeadlineExceededError(),
        after: deadline,
        tolerance: tolerance,
        clock: clock,
        isolation: isolation,
        priority: priority,
        operation: operation
    )
}

public func withDeadline<Success: Sendable>(
    until deadline: ContinuousClock.Instant,
    tolerance: Duration? = nil,
    isolation: isolated (any Actor)? = #isolation,
    priority: TaskPriority? = nil,
    @_inheritActorContext @_implicitSelfCapture operation: sending @escaping @isolated(any) () async throws -> Success
) async throws -> Success {
    try await withDeadline(
        until: deadline,
        tolerance: tolerance,
        clock: .continuous,
        isolation: isolation,
        priority: priority,
        operation: operation
    )
}
