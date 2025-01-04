import SwiftData
import SwiftUI

@Model
class History: Identifiable {
    @Attribute(.unique) var id: UUID
    var total: Int
    var win: Int
    var lose: Int
    var draw: Int
    var time: Date
    
    init(total: Int, win: Int, lose: Int, draw: Int) {
        self.id = UUID()
        self.total = total
        self.win = win
        self.lose = lose
        self.draw = draw
        self.time = Date()
    }
}
