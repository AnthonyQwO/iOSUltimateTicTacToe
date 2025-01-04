import SwiftUI
import SwiftData
import Charts

struct GameHistory: View {
    @Binding var showPage: Bool
    @Query private var Histories: [History]
    @Environment(\.modelContext) private var context
    
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
            
            //            List {
            //                ForEach(Histories) { temp in
            //                    HStack {
            //                        Text("\(temp.total)")
            //                        Text("\(temp.win)")
            //                        Text("\(temp.lose)")
            //                        Text("\(temp.time)")
            //                    }
            //                }
            //            }
            
            VStack {
                Text("Total Games: \(Histories.last?.total ?? 0)")
                    .bold()
                    .font(.title)
                    .foregroundStyle(.secondary)
                
                
                VStack {
                    // 改進的圖表視圖，顯示百分比
                    ScrollView(.horizontal) {
                        HStack {
                            Chart {
                                ForEach(Histories) { temp in
                                    LineMark(
                                        x: .value("Time", temp.total),  // X 軸顯示時間
                                        y: .value("Win Rate", Double(temp.win + temp.draw) / Double(temp.total) * 100) // Y 軸顯示勝率
                                    )
                                    .foregroundStyle(.blue)  // 設置線條顏色
                                    .lineStyle(StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))  // 改變線條樣式
                                    
                                    // 為折線圖添加點
                                    PointMark(
                                        x: .value("Time", temp.time),
                                        y: .value("Win Rate", 100.0 * Double(temp.win) / Double(temp.total))
                                    )
                                    .foregroundStyle(.blue)  // 設置點的顏
                                }
                            }
                            .frame(width: 350) // 設定圖表寬度，根據歷史數量調整
                            .padding()
                            .background(Color.secondary.opacity(0.1))  // 設定背景顏色
                            .cornerRadius(12)  // 圓角
                            .shadow(radius: 5)  // 加入陰影
                        }
                    }
                    .frame(height: 300)  // 設定圖表的高度
                    .frame(minWidth: 350)  // 設定圖表最小寬度
                    .padding()
                }
                
                
//                HStack {
//                    Button("+") {
//                        let lastHistory = Histories.last
//                        let total = (lastHistory?.total ?? 0) + 1
//                        let win = (lastHistory?.win ?? 0) + 1
//                        let lose = (lastHistory?.lose ?? 0) + 0
//                        let draw = (lastHistory?.draw ?? 0) + (0)
//                        
//                        let temp = History(total: total, win: win, lose: lose, draw: draw)
//                        
//                        context.insert(temp)
//                        
//                        do {
//                            try context.save()
//                        } catch {
//                            print("Failed to save context: \(error)")
//                        }
//                    }
//                    
//                    Button("-") {
//                        let lastHistory = Histories.last
//                        let total = (lastHistory?.total ?? 0) + 1
//                        let win = (lastHistory?.win ?? 0) + 0
//                        let lose = (lastHistory?.lose ?? 0) + 1
//                        let draw = (lastHistory?.draw ?? 0) + (0)
//                        
//                        let temp = History(total: total, win: win, lose: lose, draw: draw)
//                        
//                        context.insert(temp)
//                        
//                        do {
//                            try context.save()
//                        } catch {
//                            print("Failed to save context: \(error)")
//                        }
//                    }
//                }
                
            }
            
            // 重置按鈕，清除所有歷史紀錄
            Button("Reset") {
                // 刪除所有資料
                for history in Histories {
                    context.delete(history)
                }
                
                // 確保保存並更新資料
                do {
                    try context.save()
                } catch {
                    print("Failed to reset data: \(error)")
                }
            }
            
            Spacer()
        }
        
    }
}

#Preview {
    MainPage()
}
