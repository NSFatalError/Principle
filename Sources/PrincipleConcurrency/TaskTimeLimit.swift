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

private enum TaskTimeLimit<Success: Sendable> {

    enum Event {

        case taskFinished(Result<Success, any Error>)
        case parentTaskCancelled
        case timeLimitExceeded
    }
}

internal func withTimeLimit<C: Clock, Success: Sendable>( // swiftlint:disable:this function_parameter_count
    throwing timeLimitExceededError: @autoclosure () -> any Error,
    after deadline: C.Instant,
    tolerance: C.Instant.Duration?,
    clock: C,
    priority: TaskPriority?,
    isolation: isolated (any Actor)?,
    operation: sending @escaping () async throws -> Success
) async throws -> Success {
    var transfer = SingleUseTransfer(operation)

    let result = await withTaskGroup(
        of: TaskTimeLimit<Success>.Event.self,
        returning: Result<Success, any Error>.self,
        isolation: isolation,
        body: { group in
            var transfer = transfer.take()

            group.addTask(priority: priority) {
                do {
                    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
                    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0472-task-start-synchronously-on-caller-context.md
                    // https://forums.swift.org/t/explicitly-captured-isolated-parameter-does-not-change-isolation-of-sendable-sending-closures/79502
                    // https://forums.swift.org/t/closure-isolation-control/70378
                    let success = try await transfer.finalize()()
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
