//
//  UnsafeSendableOperation.swift
//  Principle
//
//  Created by Kamil Strzelecki on 05/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public func unsafeSendable<Success: Sendable, Failure: Error>(
    _ operation: sending @escaping @isolated(any) () async throws(Failure) -> Success
) -> UnsafeSendableOperation.WithoutArguments<Success, Failure> {
    UnsafeSendableOperation.WithoutArguments(operation)
}

public func unsafeSendable<Arg1, Success: Sendable, Failure: Error>(
    _ operation: sending @escaping @isolated(any) (Arg1) async throws(Failure) -> Success
) -> UnsafeSendableOperation.WithOneArgument<Arg1, Success, Failure> {
    UnsafeSendableOperation.WithOneArgument(operation)
}

public func unsafeSendable<Arg1, Arg2, Success: Sendable, Failure: Error>(
    _ operation: sending @escaping @isolated(any) (Arg1, Arg2) async throws(Failure) -> Success
) -> UnsafeSendableOperation.WithTwoArgument<Arg1, Arg2, Success, Failure> {
    UnsafeSendableOperation.WithTwoArgument(operation)
}

/// [GitHub Issue - Sending](https://github.com/swiftlang/swift/issues/76242)
/// [GitHub Issue - Parameter Packs](https://github.com/swiftlang/swift/issues/68755)
///
public enum UnsafeSendableOperation {

    public struct WithoutArguments<Success, Failure>: @unchecked Sendable
    where Success: Sendable, Failure: Error {

        public let perform: @isolated(any) () async throws(Failure) -> Success

        init(
            _ perform: sending @escaping @isolated(any) () async throws(Failure) -> Success
        ) {
            self.perform = perform
        }
    }

    public struct WithOneArgument<Arg1, Success, Failure>: @unchecked Sendable
    where Success: Sendable, Failure: Error {

        public let perform: @isolated(any) (Arg1) async throws(Failure) -> Success

        init(
            _ perform: sending @escaping @isolated(any) (Arg1) async throws(Failure) -> Success
        ) {
            self.perform = perform
        }
    }

    public struct WithTwoArgument<Arg1, Arg2, Success, Failure>: @unchecked Sendable
    where Success: Sendable, Failure: Error {

        public let perform: @isolated(any) (Arg1, Arg2) async throws(Failure) -> Success

        init(
            _ perform: sending @escaping @isolated(any) (Arg1, Arg2) async throws(Failure) -> Success
        ) {
            self.perform = perform
        }
    }
}
