//
//  TaskTimeLimitTests.swift
//  Principle
//
//  Created by Kamil Strzelecki on 02/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleConcurrency
import Testing

internal struct TaskTimeLimitTests {

    struct Deadline {

        @Test
        func testSuccessfulOperation() async throws {
            let result = try await withDeadline(until: .now + .seconds(1)) {
                try await Task.sleep(for: .microseconds(1))
                return true
            }
            #expect(result)
        }

        @Test
        func testThrowingOperation() async {
            await #expect(throws: CustomError.self) {
                try await withDeadline(until: .now + .seconds(1)) {
                    try await Task.sleep(for: .microseconds(1))
                    throw CustomError()
                }
            }
        }

        @Test
        func testExpiredOperation() async {
            await #expect(throws: DeadlineExceededError.self) {
                try await withDeadline(until: .now + .microseconds(1)) {
                    try await Task.sleep(for: .seconds(1))
                }
            }
        }

        @Test
        func testCancelledOperation() async {
            await #expect(throws: CancellationError.self) {
                let task = Task {
                    try await withDeadline(until: .now + .seconds(1)) {
                        try await Task.sleep(for: .seconds(1))
                    }
                }
                try await Task.sleep(for: .microseconds(1))
                task.cancel()
                try await task.value
            }
        }

        @Test
        func testIsolation() async throws {
            let task = Task { @CustomActor in
                try await withDeadline(until: .now + .seconds(1)) {
                    CustomActor.shared.assertIsolated()
                }
            }
            try await task.value
        }
    }

    struct Timeout {

        @Test
        func testSuccessfulOperation() async throws {
            let result = try await withTimeout(.seconds(1)) {
                try await Task.sleep(for: .microseconds(1))
                return true
            }
            #expect(result)
        }

        @Test
        func testThrowingOperation() async {
            await #expect(throws: CustomError.self) {
                try await withTimeout(.seconds(1)) {
                    try await Task.sleep(for: .microseconds(1))
                    throw CustomError()
                }
            }
        }

        @Test
        func testTimedOutOperation() async {
            await #expect(throws: TimeoutError.self) {
                try await withTimeout(.microseconds(1)) {
                    try await Task.sleep(for: .seconds(1))
                }
            }
        }

        @Test
        func testCancelledOperation() async {
            await #expect(throws: CancellationError.self) {
                let task = Task {
                    try await withTimeout(.seconds(1)) {
                        try await Task.sleep(for: .seconds(1))
                    }
                }
                try await Task.sleep(for: .microseconds(1))
                task.cancel()
                try await task.value
            }
        }

        @Test
        func testIsolation() async throws {
            let task = Task { @CustomActor in
                try await withTimeout(.seconds(1)) {
                    CustomActor.shared.assertIsolated()
                }
            }
            try await task.value
        }
    }
}

extension TaskTimeLimitTests {

    private struct CustomError: Error {}
}
