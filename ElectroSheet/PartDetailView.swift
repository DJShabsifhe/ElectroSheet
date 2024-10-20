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
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .foregroundColor(part.color)
                Spacer()
            }
            .padding(.bottom, 5)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Description:")
                    .font(.headline)
                Text(part.description)
                Divider()
                
                Text("Type:")
                    .font(.headline)
                Text(part.type)
                Divider()
                
                Text("Usage:")
                    .font(.headline)
                Text(part.usage)
                Divider()
                
                Text("Special:")
                    .font(.headline)
                Text(part.special)
            }
            .padding()
            .background(Color(.gray).opacity(0.1))
            .cornerRadius(20)
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Part Details")
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    
    let previewPart = PartItem(
        name: "Resistor",
        description: "A resistor is a passive two-terminal electrical component.",
        icon: "resistor",
        colorString: "blue",
        type: "Passive",
        usage: "Limits current",
        special: "None"
    )
    
    PartDetailView(part: previewPart)
}
