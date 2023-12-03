//
//  CeasarView.swift
//  Decode
//
//  Created by Kimberly Brewer on 11/20/23.
//

import SwiftUI

struct CeasarView: View {
    /// Stores the text we want to work with
    @AppStorage("cipherText") private var cipherText = ""
    /// This is attached to a slider, which must be a double
    @AppStorage("ceasarShift") private var ceasarShift = 0.0
    var shiftAmount: Int {
        Int(ceasarShift)
    }
    /// These are both shared properties amongst the various ciphers
    @AppStorage("removeSpaces") private var removeSpaces = false
    @AppStorage("reverseText") private var reverseText = false
    /// This is the string that will have taken account the above selected settings
    var preparedCipherText: String {
        var text = cipherText.uppercased()
        if removeSpaces {
            text = text.replacingOccurrences(of: " ", with: "")
        }
        if reverseText {
            text = String(text.reversed())
        }
        return text
    }
    var plainText: String {
        var result = ""
        for letter in preparedCipherText {
            // find where the letter exists
            if let index = Shared.alphabet.firstIndex(of: letter) {
                // move it desired shift amount
                let newIndex = index + shiftAmount
                // replace with new letter (the % 26 makes it so it wraps back around)
                result.append(Shared.alphabet[newIndex % 26])
            } else {
                // it wasn't found! append the original letter
                result.append(letter)
            }
        }
        return result
    }
    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $cipherText)
                .font(.system(.body, design: .monospaced))
            Divider()
            Text("Shift by \(shiftAmount)")
            Slider(value: $ceasarShift, in: 0...25, step: 1)
            Divider()
            // we want to show them the plain text but not let them edit it
            TextEditor(text: .constant(plainText))
                .font(.system(.body, design: .monospaced))
        }
        .padding()
    }
}

#Preview {
    CeasarView()
}
