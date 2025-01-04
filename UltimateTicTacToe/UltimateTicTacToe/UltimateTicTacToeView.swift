import SwiftUI

struct UltimateTicTacToeView: View {
    @Binding var game: UltimateTicTacToeGame
    @State var lineProgress: CGFloat = 0
    let animateSpeed = 1.3
    
    func startAnimation() {
        lineProgress = 1
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // 外層框架加陰影
                RoundedRectangle(cornerRadius: 50)
                    .fill(.background.quaternary)
                    .frame(width: 350, height: 350)
                    .shadow(color: .black.opacity(0.3), radius: 7, x: 5, y: 5)
                // Game Board
                VStack(spacing: 5) {
                    ZStack {
                        // 井字線
                        GeometryReader { geometry in
                            let width = geometry.size.width
                            let height = geometry.size.height
                            let lineWidth: CGFloat = 4
                            let lineColor: Color = .primary.opacity(0.7)  
                            // 水平線1
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: height / 3))
                                path.addLine(to: CGPoint(x: width, y: height / 3))
                            }
                            .trim(from: 0, to: lineProgress) // 控制線條進度
                            .stroke(lineColor, lineWidth: lineWidth)
                            .animation(.easeInOut(duration: animateSpeed), value: lineProgress)
                            // 2
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: 2 * height / 3))
                                path.addLine(to: CGPoint(x: width, y: 2 * height / 3))
                            }
                            .trim(from: 0, to: lineProgress) // 控制線條進度
                            .stroke(lineColor, lineWidth: lineWidth)
                            .animation(.easeInOut(duration: animateSpeed + 0.2).delay(0.3), value: lineProgress)
                            
                            // 垂直線1
                            Path { path in
                                path.move(to: CGPoint(x: width / 3, y: 0))
                                path.addLine(to: CGPoint(x: width / 3, y: height))
                            }
                            .trim(from: 0, to: lineProgress) // 控制線條進度
                            .stroke(lineColor, lineWidth: lineWidth)
                            .animation(.easeInOut(duration: animateSpeed), value: lineProgress)
                            // 2
                            Path { path in
                                path.move(to: CGPoint(x: 2 * width / 3, y: 0))
                                path.addLine(to: CGPoint(x: 2 * width / 3, y: height))
                            }
                            .trim(from: 0, to: lineProgress) // 控制線條進度
                            .stroke(lineColor, lineWidth: lineWidth)
                            .animation(.easeInOut(duration: animateSpeed + 0.2).delay(0.3), value: lineProgress)
                        }
                        .padding(25)
                        .onAppear {
                            startAnimation()
                        }
                        
                        // 棋子按鈕層
                        VStack(spacing: 5) {
                            ForEach(0..<3, id: \.self) { row in
                                HStack(spacing: 5) {
                                    ForEach(0..<3, id: \.self) { col in
                                        TicTacToeView(game: $game.board[row][col], currentPlayer: $game.currentPlayer, nextStep: $game.nextStep, gridDelay: col + 3 * row, recall: {
                                            game.update()
                                        })
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: 350, height: 350)
                    .cornerRadius(50)
                }
            }
        }
        .padding()
        .disabled(game.winner != nil)
    }
}

