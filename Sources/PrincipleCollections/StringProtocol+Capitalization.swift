//
//  StringProtocol+Capitalization.swift
//  Principle
//
//  Created by Kamil Strzelecki on 21/03/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import Foundation

extension StringProtocol {

    /// A copy of the string with first character changed to its corresponding uppercased spelling.
    ///
    /// Unlike `capitalized(with:)` only the first character of the result may differ.
    /// The rest of the string will be copied without any transformation applied.
    ///
    /// - Parameter locale: The locale to use for the transformation.
    /// Defaults to `nil` which is suitable for programming tasks requiring stable results.
    /// - Returns: A new string with the first character uppercased.
    ///
    public func uppercasingFirstCharacter(with locale: Locale? = nil) -> String {
        let firstLetter = prefix(1).uppercased(with: locale)
        return firstLetter + dropFirst()
    }

    /// A copy of the string with first character changed to its corresponding uppercased spelling
    /// using the user's current locale.
    ///
    /// Unlike `capitalized(with:)` only the first character of the result may differ.
    /// The rest of the string will be copied without any transformation applied.
    ///
    /// - Returns: A new string with the first character uppercased using the user's current locale.
    ///
    public func localizedUppercasingFirstCharacter() -> String {
        uppercasingFirstCharacter(with: .current)
    }
}

extension String {

    /// Uppercases the first character of the string in place.
    ///
    /// Unlike `capitalized(with:)` only the first character may change after calling this method.
    /// The rest of the string will remain unchanged.
    ///
    /// - Parameter locale: The locale to use for the transformation.
    /// Defaults to `nil` which is suitable for programming tasks requiring stable results.
    ///
    public mutating func uppercaseFirstCharacter(with locale: Locale? = nil) {
        let firstLetter = prefix(1)
        let subrange = firstLetter.startIndex ..< firstLetter.endIndex
        replaceSubrange(subrange, with: firstLetter.uppercased(with: locale))
    }

    /// Uppercases the first character of the string in place using the user's current locale.
    ///
    /// Unlike `capitalized(with:)` only the first character may change after calling this method.
    /// The rest of the string will remain unchanged.
    ///
    public mutating func localizedUppercaseFirstCharacter() {
        uppercaseFirstCharacter(with: .current)
    }
}
