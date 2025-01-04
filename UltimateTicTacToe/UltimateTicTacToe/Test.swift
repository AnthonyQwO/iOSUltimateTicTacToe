import SwiftUI

struct BouncingEllipsisView: View {
    @Binding var bounce: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.primary)
                    .offset(y: bounce ? -10 : 0)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: bounce
                    )
            }
        }
    }
}

struct BouncingDotsView: View {
    @Binding var isAnimating: Bool

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.secondary)
                        .offset(y: isAnimating ? -10 : 0) // 根據狀態改變位置
                        .animation(
                            isAnimating ?
                                Animation.easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2)
                                : .default, // 如果不動畫，使用默認位置
                            value: isAnimating
                        )
                }
            }
        }
    }
}


struct TestContentView: View {
    var bounce: Bool = false
    
    var body: some View {
        VStack {
            
            Text("Loading...")
                .font(.headline)
            // BouncingDotsView()
                .padding()
            // BouncingEllipsisView(bounce: $bounce)
        }
    }
}

#Preview {
    TestContentView()
}
