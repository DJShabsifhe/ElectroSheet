//
//  AboutAuthor.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/10/1.
//

import SwiftUI

struct AboutView: View {
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Text("DJShabsifhe")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .shadow(color: .black, radius: 10, x: 0, y: 5)

                Text("Just a random typed name.")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 5, x: 0, y: 5)

                Spacer()

                Button(action: {
                    showConfetti = true
                }) {
                    Text("ElectroSheet Version 1.0.0")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                }
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        // This is where we would adjust confetti position if needed
                    }
                })

                Spacer()
            }
            .padding()

            ConfettiView(isActive: $showConfetti)
                .opacity(showConfetti ? 1 : 0)
        }
        .navigationTitle("About Author")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutView()
}
