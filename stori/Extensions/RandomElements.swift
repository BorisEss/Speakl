//
//  RandomElements.swift
//  stori
//
//  Created by Alex on 28.01.2022.
//

import Foundation

/// Based on this link it is created the randomizing function to create a random array
/// from another array with specific number of elements
/// https://stackoverflow.com/a/28140271
///
extension RangeExpression where Bound: FixedWidthInteger {
    func randomElements(_ count: Int) -> [Bound] {
        precondition(count > 0)
        switch self {
        case let range as Range<Bound>: return (0..<count).map { _ in .random(in: range) }
        case let range as ClosedRange<Bound>: return (0..<count).map { _ in .random(in: range) }
        default: return []
        }
    }
}

extension Range where Bound: FixedWidthInteger {
    var randomElement: Bound { .random(in: self) }
}

extension ClosedRange where Bound: FixedWidthInteger {
    var randomElement: Bound { .random(in: self) }
}
