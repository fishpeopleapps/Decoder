//
//  PairCounter.swift
//  Decode
//
//  Created by Kimberly Brewer on 11/29/23.
//

import Foundation

// comparable because we want to be able to sort by a method of our choosing
struct PairCounter: Comparable {
    let letters: Substring
    let segments: ArraySlice<String>
    static func < (lhs: PairCounter, rhs: PairCounter) -> Bool {
        if lhs.segments.count == rhs.segments.count {
            // then sort by letters
            return lhs.letters < rhs.letters
        } else {
            // focus on the repeats
            return lhs.segments.count > rhs.segments.count
        }
    }
}
