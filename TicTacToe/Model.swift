//
//  Model.swift
//  TicTacToe
//
//  Created by Arhan Ashik on 2021/12/02.
//

import SwiftUI

enum GameMode {
    case singlePlayer, multiplayer
}

struct Player: Equatable {
    let who: WhichPlayer
    let type: PlayerType
}

enum WhichPlayer {
    case player1, player2
}

enum PlayerType {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player.who == .player1 ? "xmark" : "circle"
    }
}
