//
//  DeadlineExceededError.swift
//  Principle
//
//  Created by Kamil Strzelecki on 01/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

/// An error that indicates an operation has exceeded the deadline.
///
/// This error is thrown by ``withDeadline(until:tolerance:priority:isolation:operation:)`` function.
///
public struct DeadlineExceededError: Error, Equatable {}

/// A function which ensures execution is resumed by the caller before or immediately after a deadline.
///
/// - Parameters:
///   - deadline: A point in time after which `operation` will be cancelled.
///   - clock: A clock used to measure the time.
///   - priority: The priority of the task.
///   - operation: The operation to perform.
/// - Throws: Error thrown by the `operation` or ``DeadlineExceededError``.
/// - Returns: Value returned by the `operation`.
///
/// If the `operation` is still running when the `deadline` is exceeded, the child `Task` running it will be cancelled.
/// It’s the responsibility of the code running as part of the `operation` to check for cancellation to stop processing.
///
/// Any value or error produced by the `operation` after cancellation will be ignored.
///
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

/// A function which ensures execution is resumed by the caller before or immediately after a deadline.
///
/// - Parameters:
///   - deadline: A point in time after which `operation` will be cancelled.
///   - priority: The priority of the task.
///   - operation: The operation to perform.
/// - Throws: Error thrown by the `operation` or ``DeadlineExceededError``.
/// - Returns: Value returned by the `operation`.
///
/// If the `operation` is still running when the `deadline` is exceeded, the child `Task` running it will be cancelled.
/// It’s the responsibility of the code running as part of the `operation` to check for cancellation to stop processing.
///
/// Any value or error produced by the `operation` after cancellation will be ignored.
///
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
