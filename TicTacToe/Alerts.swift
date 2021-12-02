//
//  Alerts.swift
//  TicTacToe
//
//  Created by Arhan Ashik on 2021/12/02.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static func playerWin(player: WhichPlayer) -> AlertItem {
        let winner = player == .player1 ? "Player 1" : "Player 2"
        let loser = player == .player2 ? "Player 1" : "Player 2"
        return AlertItem(
            title: Text(winner + " Win!"),
            message: Text(winner + " beat " + loser),
            buttonTitle: Text("Rematch")
        )
    }
    
    static let humanWin = AlertItem(
        title: Text("You Win!"),
        message: Text("You beat the AI."),
        buttonTitle: Text("Go Again")
    )
    
    static let computerWin = AlertItem(
        title: Text("You Lost!"),
        message: Text("Your AI is super strong."),
        buttonTitle: Text("Rematch")
    )
    
    static let draw = AlertItem(
        title: Text("Draw!"),
        message: Text("It was a great battle."),
        buttonTitle: Text("Try Again")
    )
}
