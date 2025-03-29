//
//  TaskTimeLimit.swift
//  Principle
//
//  Created by Kamil Strzelecki on 01/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//
//  Based on: https://github.com/ph1ps/swift-concurrency-deadline
//  Copyright © 2024 Philipp Gabriel. Original code licensed under MIT.
//

private enum TaskTimeLimit {

    enum Event<Success: Sendable> {

        case taskFinished(Result<Success, Error>)
        case parentTaskCancelled
        case timeLimitExceeded
    }
}

internal func withTimeLimit<C: Clock, Success: Sendable>( // swiftlint:disable:this function_parameter_count
    throwing timeLimitExceededError: @autoclosure () -> Error,
    after deadline: C.Instant,
    tolerance: C.Instant.Duration?,
    clock: C,
    isolation: isolated (any Actor)?,
    priority: TaskPriority?,
    operation: sending @escaping @isolated(any) () async throws -> Success
) async throws -> Success {
    let operation = unsafeSendable(operation)

    let result = await withTaskGroup(
        of: TaskTimeLimit.Event<Success>.self,
        returning: Result<Success, Error>.self,
        isolation: isolation,
        body: { group in
            group.addTask(priority: priority) {
                do {
                    let success = try await operation.perform()
                    return .taskFinished(.success(success))
                } catch {
                    return .taskFinished(.failure(error))
                }
            }

            group.addTask(priority: priority) {
                do {
                    try await Task.sleep(until: deadline, tolerance: tolerance, clock: clock)
                    return .timeLimitExceeded
                } catch {
                    return .parentTaskCancelled
                }
            }

            defer {
                group.cancelAll()
            }

            for await event in group {
                switch event {
                case let .taskFinished(result):
                    return result
                case .timeLimitExceeded:
                    return .failure(timeLimitExceededError())
                case .parentTaskCancelled:
                    continue
                }
            }

            preconditionFailure("Operation did not return any result.")
        }
    )

    return try result.get()
}
