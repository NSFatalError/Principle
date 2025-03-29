//
//  StringProtocol+Capitalization.swift
//  Principle
//
//  Created by Kamil Strzelecki on 21/03/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

extension StringProtocol {

    public func capitalizingFirstLetter() -> String {
        let firstLetter = prefix(1).uppercased()
        return firstLetter + dropFirst()
    }
}

extension String {

    public mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }
}
