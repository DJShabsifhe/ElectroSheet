//
//  About.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/10/1.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About ElectroSheet")
                .font(.largeTitle)
                .padding()
            
            Text("ElectroSheet is a powerful tool for managing your electronic parts.")
                .font(.body)
                .padding()
            
            Text("Version 1.0.0")
                .font(.footnote)
                .padding()
            
            Spacer()
        }
        .navigationTitle("About author")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutView()
}
