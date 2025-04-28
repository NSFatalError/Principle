//
//  SingleUseTransferTests.swift
//  Principle
//
//  Created by Kamil Strzelecki on 28/04/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleConcurrency
import Synchronization
import Testing

internal struct SingleUseTransferTests {

    @Test
    func testFinalize() {
        let mutex = Mutex(NonSendable())
        let instance = NonSendable()
        var transfer = SingleUseTransfer(instance)

        mutex.withLock { protected in
            protected = transfer.finalize()
        }
    }

    @Test
    func testTake() async {
        let instance = NonSendable()
        var transfer = SingleUseTransfer(instance)

        await withTaskGroup { group in
            var transfer = transfer.take()
            group.addTask {
                _ = transfer.finalize()
            }
            await group.waitForAll()
        }
    }
}

extension SingleUseTransferTests {

    private final class NonSendable {}
}
