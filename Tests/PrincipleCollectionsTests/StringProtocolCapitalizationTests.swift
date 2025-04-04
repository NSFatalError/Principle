//
//  StringProtocolCapitalizationTests.swift
//  Principle
//
//  Created by Kamil Strzelecki on 02/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleCollections
import Foundation
import Testing

internal struct StringProtocolCapitalizationTests {

    private static let arguments: [(locale: Locale?, expectation: String)] = [
        (nil, "Istanbul city"),
        (Locale(identifier: "en_US"), "Istanbul city"),
        (Locale(identifier: "tr_TR"), "İstanbul city")
    ]

    private let string = "istanbul city"

    @Test(arguments: arguments)
    func testStringProtocol(locale: Locale?, expectation: String) {
        let substring = string[...]
        let transformed = substring.uppercasingFirstCharacter(with: locale)
        #expect(transformed == expectation)
    }

    @Test(arguments: arguments)
    func testMutableString(locale: Locale?, expectation: String) {
        var transformed = string
        transformed.uppercaseFirstCharacter(with: locale)
        #expect(transformed == expectation)
    }
}
