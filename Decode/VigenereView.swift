//
//  VigenereView.swift
//  Decode
//
//  Created by Kimberly Brewer on 11/29/23.
//

import SwiftUI

struct VigenereView: View {
    /// Stores the text we want to work with
    @AppStorage("cipherText") private var cipherText = ""
    /// These are both shared properties amongst the various ciphers
    @AppStorage("removeSpaces") private var removeSpaces = false
    @AppStorage("reverseText") private var reverseText = false
    @AppStorage("keyLength") private var keyLength = 2
    @AppStorage("keyOffset") private var keyOffset = 0
    @State private var shiftNumbers = [ShiftAmount]()
    var columns = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]
    var preparedCipherText: String  {
        var text = cipherText.uppercased()
        if removeSpaces {
            text = text.replacingOccurrences(of: " ", with: "")
        }
        if reverseText {
            text = String(text.reversed())
        }
        return text
    }
    var plaintext: String {
        guard shiftNumbers.isEmpty == false else { return "" }
        var output = ""
        var counter = 0
        for letter in preparedCipherText {
            let shift = shiftNumbers[counter]
            if let position = Shared.alphabet.firstIndex(of: letter) {
                let movement = Int(shift.content) ?? 0
                output.append(Shared.alphabet[(position + movement) % 26])
                counter += 1
                if counter == shiftNumbers.count {
                    counter = 0
                }
            } else {
                output += String(letter)
            }
        }
        return output
    }
    var keyedText: String {
        String(preparedCipherText.dropFirst(keyOffset).striding(by: keyLength))
    }
    // view
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                TextEditor(text: $cipherText)
                    .font(.system(.body, design: .monospaced))
                Divider()
                DistancesView(text: preparedCipherText)
                Divider()
                Stepper("Key Length: \(keyLength)", value: $keyLength, in: 2...25)
                    .onChange(of: keyLength) { _ in adjustShifts() }
                LazyVGrid(columns: columns) {
                    ForEach($shiftNumbers) { $number in
                        TextField("Shift", text: $number.content)
                    }
                }
                Divider()
                TextEditor(text: .constant(plaintext))
                    .font(.system(.body, design: .monospaced))
            }
            .padding()
            VStack {
                FrequencyView(text: keyedText)
                Spacer()
                Stepper("Key offset: \(keyOffset + 1)", value: $keyOffset, in: 0...keyLength - 1)
            }
            .padding()
        }
        .padding()
        .onAppear(perform: adjustShifts)
    }
    func adjustShifts() {
        let difference = keyLength - shiftNumbers.count
        if difference > 0 {
            let newArray = (0..<difference).map { _ in ShiftAmount() }
            shiftNumbers.append(contentsOf: newArray)
        } else {
            // remove as many as it takes to get it down to the right size
            shiftNumbers.removeLast(abs(difference))
        }
    }
}

#Preview {
    VigenereView()
}
