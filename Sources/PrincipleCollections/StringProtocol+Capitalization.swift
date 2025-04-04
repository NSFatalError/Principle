//
//  StringProtocol+Capitalization.swift
//  Principle
//
//  Created by Kamil Strzelecki on 21/03/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import Foundation

extension StringProtocol {

    public func uppercasingFirstCharacter(with locale: Locale? = nil) -> String {
        let firstLetter = prefix(1).uppercased(with: locale)
        return firstLetter + dropFirst()
    }

    public func localizedUppercasingFirstCharacter() -> String {
        uppercasingFirstCharacter(with: .current)
    }
}

extension String {

    public mutating func uppercaseFirstCharacter(with locale: Locale? = nil) {
        self = uppercasingFirstCharacter(with: locale)
    }

    public mutating func localizedUppercaseFirstCharacter() {
        uppercaseFirstCharacter(with: .current)
    }
}
