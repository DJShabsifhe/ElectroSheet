//
//  ConfettiView.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/10/1.
//

import SwiftUI

struct ConfettiView: View {
    @Binding var isActive: Bool
    @State private var confettiPieces: [ConfettiPiece] = []

    var body: some View {
        ZStack {
            if isActive {
                ForEach(confettiPieces) { piece in
                    Circle()
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size)
                        .offset(piece.offset)
                        .animation(
                            Animation.spring(response: 5, dampingFraction: 5, blendDuration: 5)
                                .delay(piece.delay),
                            value: isActive
                        )
                }
            }
        }
        .onAppear {
            generateConfetti()
        }
        .onChange(of: isActive) { newValue in
            if !newValue {
                confettiPieces.removeAll()
            }
        }
    }

    private func generateConfetti() {
        confettiPieces = (0..<100).map { index in
            let size = CGFloat.random(in: 5...10)
            let delay = Double(index) * 0.2
            let color = Color.random
            let offset = CGSize(width: .random(in: -100...100), height: .random(in: -200...0))
            return ConfettiPiece(size: size, color: color, offset: offset, delay: delay)
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let size: CGFloat
    let color: Color
    let offset: CGSize
    let delay: Double
}

extension Color {
    static var random: Color {
        Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
}
