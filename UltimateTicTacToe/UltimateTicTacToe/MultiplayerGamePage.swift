import SwiftUI

struct MultiplayerGamePage: View {
    @State var game = UltimateTicTacToeGame(isMultiplayer: true)
    @State var animate = false
    @State var activate = false
    @State var player: String = "X"
    let myPlayer: String
    let isHost: Bool
    @Binding var showPage: Bool
    @ObservedObject var manager: MultipeerManager
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showPage = false
                    manager.disconnect()
                    if isHost {
                        manager.stopHosting()
                    }
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
                        manager.send(message: "reset")
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
                VStack {
                    Text(game.currentPlayer == myPlayer ? "Your Turn" : "Waiting for your opponent")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.secondary)
                        .animation(.easeInOut(duration: 0.5), value: game.currentPlayer)
                        .frame(width: 350)
                    
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
                }
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
            
            MultiplayerUltimateTicTacToeView(game: $game, manager: manager, myPlayer: myPlayer)
            // .scaleEffect(1.5)
            
            Spacer()
        }
        .onChange(of: !manager.isConnected) {
            if !manager.isConnected {
                showPage = false
                if isHost {
                    manager.stopHosting()
                }
            }
        }
        .onChange(of: manager.receivedMessages) {
            if let newMessage = manager.receivedMessages.last {
                let wordsArray: [String] = newMessage.split(separator: " ").map(String.init)
                if wordsArray[0] == "reset" {
                    game.resetGame()
                    animate.toggle()
                }
                print(newMessage)
                // temp = newMessage
            }
        }
    }
}

