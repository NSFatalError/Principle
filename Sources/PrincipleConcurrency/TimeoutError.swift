//
//  TimeoutError.swift
//  Principle
//
//  Created by Kamil Strzelecki on 01/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

/// An error that indicates an operation did not complete within the time limit.
///
/// This error is thrown by ``withTimeout(_:tolerance:priority:isolation:operation:)`` function.
///
public struct TimeoutError: Error, Equatable {}

/// A function which ensures execution is resumed by the caller within a time limit or immediately after it has passed.
///
/// - Parameters:
///   - duration: A maximum amount of time `operation` can execute for, after which it will be cancelled.
///   - clock: A clock used to measure the time.
///   - priority: The priority of the task.
///   - operation: The operation to perform.
/// - Throws: Error thrown by the `operation` or ``TimeoutError``.
/// - Returns: Value returned by the `operation`.
///
/// If `operation` is running for longer than `duration`, the child `Task` running it will be cancelled.
/// It’s the responsibility of the code running as part of the `operation` to check for cancellation to stop processing.
///
/// Any value or error produced by the `operation` after cancellation will be ignored.
///
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

/// A function which ensures execution is resumed by the caller within a time limit or immediately after it has passed.
///
/// - Parameters:
///   - duration: A maximum amount of time `operation` can execute for, after which it will be cancelled.
///   - priority: The priority of the task.
///   - operation: The operation to perform.
/// - Throws: Error thrown by the `operation` or ``TimeoutError``.
/// - Returns: Value returned by the `operation`.
///
/// If `operation` is running for longer than `duration`, the child `Task` running it will be cancelled.
/// It’s the responsibility of the code running as part of the `operation` to check for cancellation to stop processing.
///
/// Any value or error produced by the `operation` after cancellation will be ignored.
///
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
        priority: priority,
        isolation: isolation,
        operation: operation
    )
}
