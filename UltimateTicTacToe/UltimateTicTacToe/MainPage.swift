import SwiftUI
import SwiftData

struct MainPage: View {
    @State private var showGamePage = false
    @State private var isFlashing = false
    @State private var isReversed = false
    @State private var showMultiplePages = false
    @State private var showHistoryPage = false
    @Query private var Histories: [History]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let timeElapsed = timeline.date.timeIntervalSince1970
            let shouldReverse = Int(timeElapsed) / 3 % 2 == 0
            
            // 使用動畫效果來變換顏色
            VStack {
                Text("Ultimate")
                    .font(.system(size: 70, weight: .bold))
                Text("Tic Tac Toe")
                    .font(.system(size: 50, weight: .bold))
            }
            .foregroundStyle(
                .linearGradient(
                    colors: shouldReverse ? [.red, .blue] : [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .padding()
            .animation(.easeInOut(duration: 1), value: shouldReverse)  // 動畫過渡效果
        }
        
        Button("StartGame") {
            showGamePage = true
        }
        .foregroundStyle(isFlashing ? .red : .purple)
        .opacity(isFlashing ? 0.5 : 1) // 控制透明度變化
        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isFlashing) // 重複動畫
        .font(.title)
        .bold()
        .padding() // 增加按鈕內部的填充
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFlashing ? Color.red : Color.purple, lineWidth: 8) // 顏色在閃爍
                .opacity(isFlashing ? 0.4 : 1) // 控制透明度變化
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isFlashing) // 重複動畫
                
        )
        .cornerRadius(10) // 讓背景和邊框的圓角一致
        .fullScreenCover(isPresented: $showGamePage) {
            GamePage(showPage: $showGamePage)
        }
        .onAppear {
            isFlashing = true
        }
        .padding()
        
        Button("Mutiplayer") {
            showMultiplePages = true
        }
        .foregroundStyle(isFlashing ? .red : .purple)
        .opacity(isFlashing ? 0.5 : 1) // 控制透明度變化
        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isFlashing) // 重複動畫
        .font(.title)
        .bold()
        .padding() // 增加按鈕內部的填充
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFlashing ? Color.red : Color.purple, lineWidth: 8) // 顏色在閃爍
                .opacity(isFlashing ? 0.4 : 1) // 控制透明度變化
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isFlashing) // 重複動畫
        )
        .cornerRadius(10) // 讓背景和邊框的圓角一致
        .fullScreenCover(isPresented: $showMultiplePages) {
            MultiplayerPage(showPage: $showMultiplePages)
        }
        .onAppear {
            isFlashing = true
        }
        .padding()
        
        Button("PlayHistory") {
            showHistoryPage = true
        }
        .foregroundStyle(isFlashing ? .red : .purple)
        .opacity(isFlashing ? 0.5 : 1) // 控制透明度變化
        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isFlashing) // 重複動畫
        .font(.title)
        .bold()
        .padding() // 增加按鈕內部的填充
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFlashing ? Color.red : Color.purple, lineWidth: 8) // 顏色在閃爍
                .opacity(isFlashing ? 0.4 : 1) // 控制透明度變化
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isFlashing) // 重複動畫
        )
        .cornerRadius(10) // 讓背景和邊框的圓角一致
        .fullScreenCover(isPresented: $showHistoryPage) {
            GameHistory(showPage: $showHistoryPage)
        }
        .onAppear {
            isFlashing = true
        }
        .padding()
    }
}

#Preview {
    MainPage()
}
