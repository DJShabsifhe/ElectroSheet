//
//  PartDetailView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/8.
//

import SwiftUI

struct PartDetailView: View {
    var part: PartItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(part.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(part.color)
                Spacer() // This ensures that the name stays on the left
            }
            .padding(.bottom, 5)

            Text("Description:")
                .font(.headline)
            Text(part.description)
                .padding(.bottom, 10)

            Text("Type:")
                .font(.headline)
            Text(part.type)
                .padding(.bottom, 10)

            Text("Usage:")
                .font(.headline)
            Text(part.usage)
                .padding(.bottom, 10)

            Text("Special:")
                .font(.headline)
            Text(part.special)
                .padding(.bottom, 10)

            Spacer()
        }
        .padding()
        .navigationTitle("Part Details") // Mac OS Compatibility
        .frame(maxWidth: .infinity, alignment: .leading) // Ensure it aligns left
    }
}

//#Preview {
//    PartDetailView()
//}
