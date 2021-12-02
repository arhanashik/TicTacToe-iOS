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
