//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Arhan Ashik on 2021/12/02.
//

import SwiftUI

final class GameViewModel: ObservableObject {
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
        
        // process humen move
        moves[position] = Move(player: .human, boardIndex: position)
        
        // check for win
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        // check for draw
        if checkDrawCondition(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameBoradDisabled = true
        
        // process computer move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerMoveIndex = determineComputerMovePosition(in: moves)
            moves[computerMoveIndex] = Move(player: .computer, boardIndex: computerMoveIndex)
            isGameBoradDisabled = false
            
            // check for win
            if checkWinCondition(for: .computer, in: moves) {
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
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        // If AI can win, then win
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for patter in winPatters {
            let winPositions = patter.subtracting(computerPositions)
            
            if winPositions.count == 1 && !isSpaceOccupied(in: moves, forIndex: winPositions.first!) {
                return winPositions.first!
            }
        }
        
        // If AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
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
