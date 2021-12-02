//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Arhan Ashik on 2021/12/02.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    init(mode: GameMode? = nil) {
        self.mode = mode ?? .singlePlayer
        
        player1 = Player(who: .player1, type: .human)
        player2 = Player(who: .player2, type: mode == .singlePlayer ? .computer : .human)
        nextPlayer = player1
    }
    
    var mode: GameMode
    var player1: Player
    var player2: Player
    var nextPlayer: Player
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoradDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSpaceOccupied(in: moves, forIndex: position) { return }
        
        // mutilplyer mode
        if(mode == .multiplayer) {
            moves[position] = Move(player: nextPlayer, boardIndex: position)
            
            // check for win
            if checkWinCondition(for: nextPlayer, in: moves) {
                alertItem = AlertContext.playerWin(player: nextPlayer.who)
                return
            }
            // check for draw
            if checkDrawCondition(in: moves) {
                alertItem = AlertContext.draw
                return
            }
            
            nextPlayer = nextPlayer == player1 ? player2 : player1
            return
        }
        
        // single player moode
        // process player move
        let player = player1.type == .human ? player1 : player2
        moves[position] = Move(player: player, boardIndex: position)
        
        // check for win
        if checkWinCondition(for: player, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        // check for draw
        if checkDrawCondition(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameBoradDisabled = true
        
        // process auto move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computer = player1.type == .computer ? player1 : player2
            let player = computer == player1 ? player2 : player1
            let computerMoveIndex = autoDetermineMovePosition(for: computer, other: player, in: moves)
            moves[computerMoveIndex] = Move(player: player2, boardIndex: computerMoveIndex)
            isGameBoradDisabled = false
            
            // check for win
            if checkWinCondition(for: player2, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            
            // check for draw
            if checkDrawCondition(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    private let winPatters: Set<Set<Int>> = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // horizontal win patterns
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // vertical win patterns
        [0, 4, 8], [2, 4, 6]             // Diagonal win patterns
    ]
    
    func isSpaceOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    // If AI can win, then win
    // If AI can't win, then block
    // If AI can't block, then take middle square
    // If Ai can't take middle square, take random available square
    func autoDetermineMovePosition(for player1: Player, other Player2: Player, in moves: [Move?]) -> Int {
        // If AI can win, then win
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == player1 }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for patter in winPatters {
            let winPositions = patter.subtracting(computerPositions)
            
            if winPositions.count == 1 && !isSpaceOccupied(in: moves, forIndex: winPositions.first!) {
                return winPositions.first!
            }
        }
        
        // If AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == Player2 }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        for patter in winPatters {
            let winPositions = patter.subtracting(humanPositions)
            
            if winPositions.count == 1 && !isSpaceOccupied(in: moves, forIndex: winPositions.first!) {
                return winPositions.first!
            }
        }
        
        // If AI can't block, then take middle square
        let middlePosition = 4
        if !isSpaceOccupied(in: moves, forIndex: middlePosition) { return middlePosition }
        
        // If Ai can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSpaceOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for patter in winPatters where patter.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkDrawCondition(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
