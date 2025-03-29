//
//  VeryUnsafeSendableOperation.swift
//  Principle
//
//  Created by Kamil Strzelecki on 09/03/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public func veryUnsafeSendable<Success: Sendable, Failure: Error>(
    _ operation: @escaping @isolated(any) () async throws(Failure) -> Success
) -> VeryUnsafeSendableOperation.WithoutArguments<Success, Failure> {
    VeryUnsafeSendableOperation.WithoutArguments(operation)
}

public func veryUnsafeSendable<Arg1, Success: Sendable, Failure: Error>(
    _ operation: @escaping @isolated(any) (Arg1) async throws(Failure) -> Success
) -> VeryUnsafeSendableOperation.WithOneArgument<Arg1, Success, Failure> {
    VeryUnsafeSendableOperation.WithOneArgument(operation)
}

public func veryUnsafeSendable<Arg1, Arg2, Success: Sendable, Failure: Error>(
    _ operation: @escaping @isolated(any) (Arg1, Arg2) async throws(Failure) -> Success
) -> VeryUnsafeSendableOperation.WithTwoArgument<Arg1, Arg2, Success, Failure> {
    VeryUnsafeSendableOperation.WithTwoArgument(operation)
}

/// [GitHub Issue - Parameter Packs](https://github.com/swiftlang/swift/issues/68755)
///
public enum VeryUnsafeSendableOperation {

    public struct WithoutArguments<Success, Failure>: @unchecked Sendable
    where Success: Sendable, Failure: Error {

        public let perform: @isolated(any) () async throws(Failure) -> Success

        init(
            _ perform: @escaping @isolated(any) () async throws(Failure) -> Success
        ) {
            self.perform = perform
        }
    }

    public struct WithOneArgument<Arg1, Success, Failure>: @unchecked Sendable
    where Success: Sendable, Failure: Error {

        public let perform: @isolated(any) (Arg1) async throws(Failure) -> Success

        init(
            _ perform: @escaping @isolated(any) (Arg1) async throws(Failure) -> Success
        ) {
            self.perform = perform
        }
    }

    public struct WithTwoArgument<Arg1, Arg2, Success, Failure>: @unchecked Sendable
    where Success: Sendable, Failure: Error {

        public let perform: @isolated(any) (Arg1, Arg2) async throws(Failure) -> Success

        init(
            _ perform: @escaping @isolated(any) (Arg1, Arg2) async throws(Failure) -> Success
        ) {
            self.perform = perform
        }
    }
}
