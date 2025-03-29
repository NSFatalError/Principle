//
//  TaskTimeLimitTests.swift
//  Principle
//
//  Created by Kamil Strzelecki on 02/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import Principle
import Testing

internal struct TaskTimeLimitTests {

    struct Deadline {

        @Test
        func testSuccessfulOperation() async throws {
            let result = try await withDeadline(until: .now + .seconds(1)) {
                try await Task.sleep(for: .microseconds(13))
                return true
            }
            #expect(result)
        }

        @Test
        func testThrowingOperation() async throws {
            try await withKnownIssue {
                try await withDeadline(until: .now + .seconds(1)) {
                    try await Task.sleep(for: .microseconds(1))
                    throw CustomError()
                }
            } matching: { issue in
                issue.error is CustomError
            }
        }

        @Test
        func testExpiredOperation() async throws {
            try await withKnownIssue {
                try await withDeadline(until: .now + .microseconds(1)) {
                    try await Task.sleep(for: .seconds(1))
                }
            } matching: { issue in
                issue.error is DeadlineExceededError
            }
        }

        @Test
        func testCancelledOperation() async throws {
            try await withKnownIssue {
                let task = Task {
                    try await withDeadline(until: .now + .seconds(1)) {
                        try await Task.sleep(for: .seconds(1))
                    }
                }
                try await Task.sleep(for: .microseconds(1))
                task.cancel()
                try await task.value
            } matching: { issue in
                issue.error is CancellationError
            }
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
        func testThrowingOperation() async throws {
            try await withKnownIssue {
                try await withTimeout(.seconds(1)) {
                    try await Task.sleep(for: .microseconds(1))
                    throw CustomError()
                }
            } matching: { issue in
                issue.error is CustomError
            }
        }

        @Test
        func testTimedOutOperation() async throws {
            try await withKnownIssue {
                try await withTimeout(.microseconds(1)) {
                    try await Task.sleep(for: .seconds(1))
                }
            } matching: { issue in
                issue.error is TimeoutError
            }
        }

        @Test
        func testCancelledOperation() async throws {
            try await withKnownIssue {
                let task = Task {
                    try await withTimeout(.seconds(1)) {
                        try await Task.sleep(for: .seconds(1))
                    }
                }
                try await Task.sleep(for: .microseconds(1))
                task.cancel()
                try await task.value
            } matching: { issue in
                issue.error is CancellationError
            }
        }
    }
}

extension TaskTimeLimitTests {

    private struct CustomError: Error {}
}
