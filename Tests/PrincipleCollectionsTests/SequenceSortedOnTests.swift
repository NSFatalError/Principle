//
//  SequenceSortedOnTests.swift
//  Principle
//
//  Created by Kamil Strzelecki on 01/04/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleCollections
import Testing

internal struct SequenceSortedOnTests {

    private let range = 0 ..< 10

    private var shuffled: [Box] {
        range.shuffled().map(Box.init)
    }

    @Test
    func testSequence() {
        let sorted = shuffled.sorted(on: \.value)
        #expect(Array(range) == sorted.map(\.value))
    }

    @Test
    func testReversedSequence() {
        let sorted = shuffled.sorted(on: \.value, by: >)
        #expect(Array(range).reversed() == sorted.map(\.value))
    }

    @Test
    func testMutableCollection() {
        var sorted = shuffled
        sorted.sort(on: \.value)
        #expect(Array(range) == sorted.map(\.value))
    }

    @Test
    func testReversedMutableCollection() {
        var sorted = shuffled
        sorted.sort(on: \.value, by: >)
        #expect(Array(range).reversed() == sorted.map(\.value))
    }
}

extension SequenceSortedOnTests {

    private struct Box {

        let value: Int
    }
}
