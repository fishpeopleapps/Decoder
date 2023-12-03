//
//  FrequencyView.swift
//  Decode
//
//  Created by Kimberly Brewer on 12/2/23.
//

import SwiftUI

struct FrequencyView: View {
    let text: String
    var body: some View {
        Text(parsedFrequencies)
            .frame(width: 100)
    }
    // This is kind of interesting it's like a workaround? for this dynamic text?
    var parsedFrequencies: String {
        var results = [Character: Int]()
        for character in text {
            if character.isLetter == false { continue }
            results[character, default: 0] += 1
        }
        var output = [String]()
        // give us the most common letters first
        let sortedResults = results.sorted { $0.value > $1.value }
        for (index, item) in sortedResults.enumerated() {
            let suggestedLetter = Shared.frequencies[index]
            
            var shift = 0
            if let firstPosition = Shared.alphabet.firstIndex(of: item.key) {
                if let secondPosition = Shared.alphabet.firstIndex(of: suggestedLetter) {
                    shift = secondPosition - firstPosition
                    if shift < -0 {
                        shift += 26
                    }
                }
            }
            output.append("\(item.key): \(item.value) - \(suggestedLetter) (\(shift))?")
        }
        return output.joined(separator: "\n")
    }
}

#Preview {
    FrequencyView(text: "Hello World")
}
