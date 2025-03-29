//
//  TimeoutError.swift
//  Principle
//
//  Created by Kamil Strzelecki on 01/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public struct TimeoutError: Error {}

public func withTimeout<C: Clock, Success: Sendable>(
    _ duration: C.Instant.Duration,
    tolerance: C.Instant.Duration? = nil,
    clock: C,
    isolation: isolated (any Actor)? = #isolation,
    priority: TaskPriority? = nil,
    @_inheritActorContext @_implicitSelfCapture operation: sending @escaping @isolated(any) () async throws -> Success
) async throws -> Success {
    try await withTimeLimit(
        throwing: TimeoutError(),
        after: clock.now.advanced(by: duration),
        tolerance: tolerance,
        clock: clock,
        isolation: isolation,
        priority: priority,
        operation: operation
    )
}

public func withTimeout<Success: Sendable>(
    _ duration: Duration,
    tolerance: Duration? = nil,
    isolation: isolated (any Actor)? = #isolation,
    priority: TaskPriority? = nil,
    @_inheritActorContext @_implicitSelfCapture operation: sending @escaping @isolated(any) () async throws -> Success
) async throws -> Success {
    try await withTimeout(
        duration,
        tolerance: tolerance,
        clock: .continuous,
        isolation: isolation,
        priority: priority,
        operation: operation
    )
}
