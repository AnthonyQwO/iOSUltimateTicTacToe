import SwiftUI

struct GamePage: View {
    @State var game = UltimateTicTacToeGame(isMultiplayer: false)
    @State var animate = false
    @Binding var showPage: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showPage = false
                }, label: {
                    Image(systemName: "arrow.uturn.left")
                        .font(.title)
                        .bold()
                        .background(.clear)
                        .foregroundColor(.secondary)
                        .cornerRadius(10)
                })
                .padding()
                Spacer()
                HStack {
                    Button(action: {
                        game.resetGame()
                        animate.toggle()
                    }, label: {
                        Image(systemName: "arrow.circlepath")
                            .font(.title)
                            .bold()
                            .background(.clear)
                            .foregroundColor(.secondary)
                            .cornerRadius(10)
                            .symbolEffect(.bounce.down, value: animate)
                    })
                    .padding()
                }
                
            }
            
            if game.winner == nil {
                HStack {
                    Image(systemName: game.currentPlayer == "X" ? "xmark" : "circle")
                        .foregroundColor(game.currentPlayer == "X" ? .red : .blue) // 修改 X 的顏色
                        .bold()
                        .opacity(1)
                        .frame(width: 20, height: 20)
                        .contentTransition(.symbolEffect(.replace))
                    Text("'s Turn")
                        .foregroundColor(.secondary)
                }
                .font(.title)
                .padding()
            }
            else {
                if game.winner == "tie" {
                    Text("Game Tie!")
                        .foregroundColor(.secondary)
                        .font(.title)
                        .padding()
                        .opacity(game.winner == nil ? 0 : 1)
                        .animation(.easeInOut(duration: 0.5), value: game.winner)
                }
                else {
                    HStack {
                        Image(systemName: game.winner == "X" ? "xmark" : "circle")
                            .foregroundColor(game.winner == "X" ? .red : .blue) // 修改 X 的顏色
                            .bold()
                            .opacity(1)
                        Text("is Winner!!")
                            .foregroundColor(.secondary)
                    }
                    .font(.title)
                    .padding()
                    .opacity(game.winner == nil ? 0 : 1)
                    .animation(.easeInOut(duration: 0.5), value: game.winner)
                }
            }
            
            UltimateTicTacToeView(game: $game)
                // .scaleEffect(1.5)
            
            Spacer()
        }
    }
}

