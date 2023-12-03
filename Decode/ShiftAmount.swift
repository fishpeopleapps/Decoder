//
//  shiftAmount.swift
//  Decode
//
//  Created by Kimberly Brewer on 11/21/23.
//

import Foundation

/// This is a workaround because we are unable to refer to the shift amount as an Int
struct ShiftAmount: Identifiable {
    var id = UUID()
    var content = "1"
}
