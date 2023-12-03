//
//  ColumnarView.swift
//  Decode
//
//  Created by Kimberly Brewer on 11/21/23.
//
// TODO: SwiftLint
// TODO: Update Deprecrated code
// TODO:

import Algorithms
import SwiftUI

struct ColumnarView: View {
    @State private var columnOrder = [ShiftAmount]()
    var columns = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]
    /// Stores the text we want to work with
    @AppStorage("cipherText") private var cipherText = ""
    @AppStorage("columnCount") private var columnCount = 2
    /// These are both shared properties amongst the various ciphers
    @AppStorage("removeSpaces") private var removeSpaces = false
    @AppStorage("reverseText") private var reverseText = false
    /// This is the string that will have taken account the above selected settings
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
    var plainText: String {
        let input = preparedCipherText
        let chunkLength = input.count / columnCount
        guard chunkLength > 0 else { return "" }
        // This is what we're using from SwiftAlgorithms, then we're mapping it into an array
        // and each column into an array as well
        let parts = input.chunks(ofCount: chunkLength).map(Array.init)
        guard let firstPart = parts.first else { return "" }
        var rearranged = ""
        for index in 0..<firstPart.count {
            // go through all of the letters in each row
            for part in parts {
                // check and see if there is an uneven column
                if index < part.count {
                    rearranged.append(part[index])
                }
            }
        }
        let wordParts = rearranged.chunks(ofCount: columnCount).map(Array.init)
        var finalOutput = ""
        for part in wordParts {
            for amount in columnOrder {
                let amount = Int(amount.content) ?? 1
                if amount > 0 && amount <= part.count {
                    finalOutput.append(part[amount - 1])
                }
            }
        }
        return finalOutput
    }

    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $cipherText)
                .font(.system(.body, design: .monospaced))
            Divider()
            Stepper("Columns: \(columnCount)", value: $columnCount, in: 2...25)
                .onChange(of: columnCount) { _ in adjustShifts() }
            LazyVGrid(columns: columns) {
                ForEach($columnOrder) { $number in
                    TextField("Shift", text: $number.content)
                }
            }
            Divider()
            TextEditor(text: .constant(plainText))
                .font(.system(.body, design: .monospaced))
        }
        .padding()
        .onAppear(perform: adjustShifts)
    }
    /// Allows us to make shifts/changes after we sort our chunks into columns
    func adjustShifts() {
        let difference = columnCount - columnOrder.count
        if difference > 0 {
            let newArray = (columnOrder.count..<columnCount).map { num in
                ShiftAmount(content: String(num + 1))
            }
            columnOrder.append(contentsOf: newArray)
        } else if difference < 0 {
            columnOrder.removeLast(abs(difference))
        }
    }
}

#Preview {
    ColumnarView()
}
