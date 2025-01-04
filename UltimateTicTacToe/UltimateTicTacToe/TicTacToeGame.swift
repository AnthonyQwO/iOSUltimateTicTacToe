import SwiftUI

@Observable class TicTacToeGame {
    var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    var winner: String? = nil
    var activate: Bool = true
    
    func makeMove(row: Int, col: Int, currentPlayer: String) {
        guard board[row][col] == "" else { return }
        board[row][col] = currentPlayer
        // nextStep = row * 3 + col
        // print(nextStep)
        if checkWinner(for: currentPlayer) {
            winner = currentPlayer
            activate = false
        }
        else if isBoardFull() {
            winner = "tie"
            activate = false
        }
    }
    
    func checkWinner(for player: String) -> Bool {
        // Check rows and columns
        for i in 0..<3 {
            if board[i].allSatisfy({ $0 == player }) || (0..<3).allSatisfy({ board[$0][i] == player }) {
                return true
            }
        }
        // Check diagonals
        if (0..<3).allSatisfy({ board[$0][$0] == player }) || (0..<3).allSatisfy({ board[$0][2 - $0] == player }) {
            return true
        }
        return false
    }
    
    func isBoardFull() -> Bool {
        return board.allSatisfy { row in
            row.allSatisfy { cell in
                cell != ""
            }
        }
    }
    
    func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        winner = nil
        activate = true
    }
}
