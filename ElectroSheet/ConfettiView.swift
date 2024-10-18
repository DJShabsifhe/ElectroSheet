import SwiftUI

struct ConfettiView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            if isActive {
                ForEach(0..<100, id: \.self) { _ in
                    Circle()
                        .fill(Color.random) // Random color
                        .frame(width: 5, height: 5)
                        .offset(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -300...0))
                        .animation(
                            Animation.interpolatingSpring(stiffness: 50, damping: 5)
                                .delay(Double.random(in: 0...1))
                                .repeatCount(1, autoreverses: false),
                            value: isActive
                        )
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isActive = false
            }
        }
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}