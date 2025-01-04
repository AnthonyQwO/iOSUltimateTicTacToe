import SwiftUI

struct MultiplayerPage: View {
    @StateObject private var manager = MultipeerManager()
    @State private var showSettingPage = false
    @State private var isFlashing = false
    @State private var isReversed = false
    @State private var isFullScreenPresented: Bool = false
    @State private var bounce: Bool = false
    @State var myPlayer: String = "X"
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
            }
            
            Button("Create Room") {
                showSettingPage = true
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
            .fullScreenCover(isPresented: $showSettingPage) {
                MultiplayerSettingPage(showPage: $showSettingPage, manager: manager)
            }
            .onAppear {
                isFlashing = true
            }
            .padding()
            
            BouncingDotsView(isAnimating: $bounce)
                .padding()
                .onAppear() {
                    bounce = true
                }
            
            List(manager.availableRooms, id: \.peerID) { room in
                HStack {
                    if let gameMode = room.info["gameMode"] {
                        if gameMode == "0" {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .font(.title2)
                        } else if gameMode == "1" {
                            Image(systemName: "circle")
                                .foregroundColor(.blue)
                                .font(.title2)
                        } else {
                            Text("未知")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                     
                    Text("\(room.info["roomName"] ?? "未知")")
                        .font(.title2)
                }
                .bold()
                .padding()
                .onTapGesture {
                    manager.joinRoom(peerID: room.peerID)
                    myPlayer = room.info["gameMode"] == "1" ? "X" : "O"
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
                    .shadow(color: .gray.opacity(0.5), radius: 3, x: 0, y: 2)
            )
            .padding()
            .listStyle(PlainListStyle())
            .padding()
            
            Spacer()
        }
        .onAppear {
            manager.startBrowsing()
        }
        .onChange(of: manager.isConnected) {
            if manager.isConnected {
                isFullScreenPresented = true
            }
        }
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            MultiplayerGamePage(myPlayer: myPlayer, isHost: false, showPage: $isFullScreenPresented, manager: manager)
        }
        
    }
    
}

#Preview {
    MainPage()
}
