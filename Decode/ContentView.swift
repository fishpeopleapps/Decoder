//
//  ContentView.swift
//  Decode
//
//  Created by Kimberly Brewer on 11/13/23.
//

import SwiftUI

struct ContentView: View {
    /// These are both shared properties amongst the various ciphers
    @AppStorage("removeSpaces") private var removeSpaces = false
    @AppStorage("reverseText") private var reverseText = false
    /// Scene storage only shares this variable with this view
    @SceneStorage("selectedTab") private var selectedTab = "Caesar"

    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                CeasarView()
                    .tabItem {
                        Text("Caesar")
                    }
                    .tag("Cesar")
                ColumnarView()
                    .tabItem {
                        Text("Columnar")
                    }
                    .tag("Column")
                VigenereView()
                    .tabItem {
                        Text("Vigenere")
                    }
                    .tag("Vigenere")
            }
            .padding()
            HStack {
                Toggle("Remove spaces", isOn: $removeSpaces)
                Toggle("Reverse text", isOn: $reverseText)
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    ContentView()
}
