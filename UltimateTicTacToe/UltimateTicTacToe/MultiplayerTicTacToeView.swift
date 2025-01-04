import SwiftUI

struct MultiplayerTicTacToeView: View {
    @Binding var game: TicTacToeGame
    @Binding var currentPlayer: String
    @Binding var nextStep: Int
    @Binding var x: Int
    @Binding var y: Int
    @State private var lineProgress: CGFloat = 0
    let animateSpeed: CGFloat = 0.6
    let mainDelay: CGFloat = 0.3
    let dDelay: CGFloat = 0.08
    var boardSize: CGFloat = 260 / 2.7
    var gridDelay: Int
    let recall: () -> Void
    
    func startAnimation() {
        lineProgress = 1
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Game Board
            VStack(spacing: 5) {
                ZStack {
                    // 井字線
                    GeometryReader { geometry in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let lineWidth: CGFloat = 2
                        
                        // 水平線1
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: height /  3))
                            path.addLine(to: CGPoint(x: width, y: height / 3))
                        }
                        .trim(from: 0, to: lineProgress) // 控制線條進度
                        .stroke(Color.secondary, lineWidth: lineWidth)
                        .animation(.easeInOut(duration: animateSpeed).delay(dDelay * CGFloat(gridDelay) + mainDelay), value: lineProgress)
                        // 2
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 2 * height / 3))
                            path.addLine(to: CGPoint(x: width, y: 2 * height / 3))
                        }
                        .trim(from: 0, to: lineProgress) // 控制線條進度
                        .stroke(Color.secondary, lineWidth: lineWidth)
                        .animation(.easeInOut(duration: animateSpeed - 0.1).delay(0.3 + dDelay * CGFloat(gridDelay) + mainDelay), value: lineProgress)
                        
                        // 垂直線1
                        Path { path in
                            path.move(to: CGPoint(x: width / 3, y: 0))
                            path.addLine(to: CGPoint(x: width / 3, y: height))
                        }
                        .trim(from: 0, to: lineProgress) // 控制線條進度
                        .stroke(Color.secondary, lineWidth: lineWidth)
                        .animation(.easeInOut(duration: animateSpeed).delay(dDelay * CGFloat(gridDelay) + mainDelay), value: lineProgress)
                        // 2
                        Path { path in
                            path.move(to: CGPoint(x: 2 * width / 3, y: 0))
                            path.addLine(to: CGPoint(x: 2 * width / 3, y: height))
                        }
                        .trim(from: 0, to: lineProgress) // 控制線條進度
                        .stroke(Color.secondary, lineWidth: lineWidth)
                        .animation(.easeInOut(duration: animateSpeed - 0.1).delay(0.3 + dDelay * CGFloat(gridDelay) + mainDelay), value: lineProgress)
                        
                    }
                    .padding(10)
                    .opacity(game.activate ? 1 : 0.2)
                    .animation(.easeInOut(duration: 0.3), value: game.activate)
                    .onAppear {
                        startAnimation()
                    }
                    
                    // 棋子按鈕層
                    VStack(spacing: 5) {
                        ForEach(0..<3, id: \.self) { row in
                            HStack(spacing: 5) {
                                ForEach(0..<3, id: \.self) { col in
                                    Button(action: {
                                        x = row
                                        y = col
                                        game.makeMove(row: row, col: col, currentPlayer: currentPlayer)
                                        nextStep = row * 3 + col
                                        recall()
                                        // print(nextStep)
                                    }) {
                                        ZStack {
                                            // 背景顏色（可省略或改為透明）
                                            Color.clear
                                            
                                            // 使用 SF Symbol 顯示 X 或 O
                                            if game.board[row][col] == "X" || game.board[row][col] == "O" {
                                                Image(systemName: game.board[row][col] == "X" ? "xmark" : "circle")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(game.board[row][col] == "X" ? .red : .blue) // 修改 X 的顏色
                                                    .padding(1) // 確保符號有內邊距
                                                    .bold()
                                                    .opacity(game.board[row][col] == "" ? 0 : 1)
                                                .animation(.easeInOut(duration: 0.1), value: game.board[row][col])
                                            }
                                            
                                        }
                                        .frame(width: boardSize / 260 * 50, height: boardSize / 260 * 50) // 確保按鈕大小一致
                                        .background(Color.gray.opacity(0)) // 格子背景顏色
                                        .padding(1)
                                    }
                                    .disabled(game.board[row][col] != "" || game.winner != nil || !game.activate)
                                    
                                }
                            }
                        }
                    }
                    .opacity(game.activate ? 1 : 0.2)
                    .animation(.easeInOut(duration: 0.3), value: game.activate)
                    
                    ZStack {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red) // 修改 X 的顏色
                            .padding(5) // 確保符號有內邊距
                            .bold()
                            .opacity(game.winner == "X" ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: game.winner)
                        Image(systemName: "circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue) // 修改 X 的顏色
                            .padding(5) // 確保符號有內邊距
                            .bold()
                            .opacity(game.winner == "O" ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: game.winner)
                    }
                    
                }
                .frame(width: boardSize, height: boardSize)
                .background(Color.gray.opacity(0))
                .cornerRadius(0)
            }
        }
        .padding(0)
    }
}
