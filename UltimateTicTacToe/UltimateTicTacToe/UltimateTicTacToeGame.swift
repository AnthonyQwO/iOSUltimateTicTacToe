import SwiftUI

@Observable class UltimateTicTacToeGame {
    var board: [[TicTacToeGame]]
    var currentPlayer = "X"
    var winner: String? = nil
    var nextStep: Int = -1
    var animate: Bool = false
    let isMultiplayer: Bool
    
    init(isMultiplayer: Bool) {
        self.board = (0..<3).map { _ in (0..<3).map { _ in TicTacToeGame() } }
        self.isMultiplayer = isMultiplayer
    }
    
    func update() {
        if board[nextStep / 3][nextStep % 3].winner == nil {
            for row in 0..<3 {
                for col in 0..<3 {
                    if nextStep == row * 3 + col && board[row][col].winner == nil {
                        board[row][col].activate = true
                    }
                    else {
                        board[row][col].activate = false
                    }
                }
            }
        }
        else {
            for row in 0..<3 {
                for col in 0..<3 {
                    if nextStep == row * 3 + col || board[row][col].winner != nil {
                        board[row][col].activate = false
                    }
                    else {
                        board[row][col].activate = true
                    }
                }
            }
        }
        if checkWinner(for: currentPlayer) {
            winner = currentPlayer
        }
        else if isBoardFull() {
            winner = "tie"
        }
        else {
            currentPlayer = currentPlayer == "X" ? "O" : "X"
            // animate.toggle()
        }
    }
    
    //    
    func checkWinner(for player: String) -> Bool {
        // Check rows and columns
        for i in 0..<3 {
            if board[i].allSatisfy({ $0.winner == player }) || (0..<3).allSatisfy({ board[$0][i].winner == player }) {
                return true
            }
        }
        // Check diagonals
        if (0..<3).allSatisfy({ board[$0][$0].winner == player }) || (0..<3).allSatisfy({ board[$0][2 - $0].winner == player }) {
            return true
        }
        return false
    }
    
    func isBoardFull() -> Bool {
        for row in 0..<3 {
            for col in 0..<3 {
                if board[row][col].winner == nil {
                    return false
                }
            }
        }
        return true
    }
    
    func resetGame() {
        currentPlayer = "X"
        winner = nil
        for row in 0..<3 {
            for col in 0..<3 {
                board[row][col].resetGame()
            }
        }
    }
}
