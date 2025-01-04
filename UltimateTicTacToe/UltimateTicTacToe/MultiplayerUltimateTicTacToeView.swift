import SwiftUI
import SwiftData

struct MultiplayerUltimateTicTacToeView: View {
    @Binding var game: UltimateTicTacToeGame
    @State var lineProgress: CGFloat = 0
    @State var x: Int = 0
    @State var y: Int = 0
    @ObservedObject var manager: MultipeerManager
    let animateSpeed = 1.3
    let myPlayer: String
    
    @Query private var Histories: [History]
    @Environment(\.modelContext) private var context
    
    
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
                                        MultiplayerTicTacToeView(game: $game.board[row][col], currentPlayer: $game.currentPlayer, nextStep: $game.nextStep, x: $x, y: $y, gridDelay: col + 3 * row, recall: {
                                            game.update()
                                            manager.send(message: "\(myPlayer) \(row) \(col) \(x) \(y)")
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
        .disabled(game.winner != nil || game.currentPlayer != myPlayer)
        .opacity(game.currentPlayer != myPlayer ? 0.3 : 1)
        .onChange(of: manager.receivedMessages) {
            if let newMessage = manager.receivedMessages.last {
                let wordsArray: [String] = newMessage.split(separator: " ").map(String.init)
                if wordsArray[0] == "X" || wordsArray[0] == "O" {
                    let X: Int = Int(wordsArray[1]) ?? 0
                    let Y: Int = Int(wordsArray[2]) ?? 0
                    let x: Int = Int(wordsArray[3]) ?? 0
                    let y: Int = Int(wordsArray[4]) ?? 0
                    game.nextStep = x * 3 + y
                    game.board[X][Y].makeMove(row: x, col: y, currentPlayer: game.currentPlayer)
                    game.update()
                }
                // print(newMessage)
                // temp = newMessage
            }
        }
        .onChange(of: game.winner) {
            if game.winner != nil {
                let lastHistory = Histories.last
                let total = (lastHistory?.total ?? 0) + 1
                let win = (lastHistory?.win ?? 0) + (game.winner == myPlayer ? 1 : 0)
                let lose = (lastHistory?.lose ?? 0) + (game.winner != myPlayer && game.winner != "tie" ? 1 : 0)
                let draw = (lastHistory?.draw ?? 0) + (game.winner == "tie" ? 1 : 0)

                let temp = History(total: total, win: win, lose: lose, draw: draw)

                context.insert(temp)
                
                do {
                    try context.save()
                } catch {
                    print("Failed to save context: \(error)")
                }
            }
        }
    }
}

