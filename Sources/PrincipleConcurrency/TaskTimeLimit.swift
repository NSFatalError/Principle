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

internal enum TaskTimeLimit<Success: Sendable> {

    typealias Operation = @isolated(any) () async throws -> Success

    fileprivate enum Event {

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
    isolation callerIsolation: isolated (any Actor)?,
    operation: sending @escaping TaskTimeLimit<Success>.Operation
) async throws -> Success {
    var transfer = SingleUseTransfer(operation)

    let result = await withTaskGroup(
        of: TaskTimeLimit<Success>.Event.self,
        returning: Result<Success, any Error>.self,
        isolation: callerIsolation,
        body: { group in
            group.addTask(priority: priority) {
                do {
                    try await Task.sleep(until: deadline, tolerance: tolerance, clock: clock)
                    return .timeLimitExceeded
                } catch {
                    return .parentTaskCancelled
                }
            }

            do {
                nonisolated(unsafe) var unsafeGroup = group
                defer { group = consume unsafeGroup }

                await unpackOperation(
                    transfer.finalize(),
                    callerIsolation: callerIsolation,
                    transform: { operation, operationIsolation in
                        unsafeGroup.addTask(priority: priority) {
                            do {
                                _ = operationIsolation
                                let success = try await operation()
                                return .taskFinished(.success(success))
                            } catch {
                                return .taskFinished(.failure(error))
                            }
                        }
                    }
                )
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

private func unpackOperation<Success: Sendable, R>(
    _ operation: sending @escaping TaskTimeLimit<Success>.Operation,
    callerIsolation _: isolated (any Actor)?,
    transform: (sending @escaping TaskTimeLimit<Success>.Operation, isolated(any Actor)?) -> sending R
) async -> sending R {
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    // https://forums.swift.org/t/closure-isolation-control/70378

    // Currently operationIsolation does not affect actual isolation of child task.
    // https://forums.swift.org/t/explicitly-captured-isolated-parameter-does-not-change-isolation-of-sendable-sending-closures/79502
    let operationIsolation = extractIsolation(operation)

    return await transform(operation, operationIsolation)
}
