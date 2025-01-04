import SwiftUI

struct MultiplayerSettingPage: View {
    @Binding var showPage: Bool
    @ObservedObject var manager: MultipeerManager
    @State var roomName: String = ""
    @State private var selectedOption = 0  // 儲存選擇的選項，初始設為 0
    @State var showButton: Bool = true
    @State private var isFullScreenPresented: Bool = false
    @State var myPlayer: String = "X"
    @State var bounce: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                showPage = false
                manager.stopHosting()
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
        
        VStack {
            Text(showButton ? "Create Room" : "Watting For Players...")
                .bold()
                .frame(width: 350)
                .foregroundColor(.secondary)
                .font(.title)
                .padding()
            
            TextField("Enter Room Name", text: $roomName)
                .font(.title)
                .bold()
                .padding() // 增加內部填充
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 5) // 邊框樣式
                        .frame(width: 300)
                )
                .padding(.horizontal) // 增加外部填充
                .frame(width: 300)
            
            Picker("Select", selection: $selectedOption) {
                Image(systemName: "xmark")
                    .tag(0)
                Image(systemName: "circle")
                    .tag(1)
            }
            .pickerStyle(.wheel)
            .frame(width: 300, height: 100)
            .background(.quaternary)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.3), radius: 7, x: 5, y: 5)
            .padding()
            
            BouncingDotsView(isAnimating: $bounce)
                .padding()
            
            if showButton {
                Button("Create Room") {
                    showButton.toggle()
                    bounce = true
                    manager.startHosting(roomInfo: [
                        "roomName": roomName,
                        "gameMode": String(selectedOption)
                    ])
                    myPlayer = selectedOption == 0 ? "X" : "O"
                }
                .foregroundStyle(.green)
                .font(.title)
                .bold()
                .padding() // 增加按鈕內部的填充
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 8)
                )
                .cornerRadius(10)
                .padding()
            }
            else {
                Button("Stop") {
                    showButton.toggle()
                    bounce = false
                    manager.stopHosting()
                }
                .foregroundStyle(.red)
                .font(.title)
                .bold()
                .padding() // 增加按鈕內部的填充
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 8)
                )
                .cornerRadius(10)
                .padding()
            }
        }
        .onChange(of: manager.isConnected) {
            if manager.isConnected {
                showButton.toggle()
                bounce = false
                isFullScreenPresented = true
                // showButton.toggle()
            }
        }
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            MultiplayerGamePage(myPlayer: myPlayer, isHost: true, showPage: $isFullScreenPresented, manager: manager)
        }
                
        Spacer()
    }
}

#Preview {
    MainPage()
}
