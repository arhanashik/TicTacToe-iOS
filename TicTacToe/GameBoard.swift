//
//  GameBoard.swift
//  TicTacToe
//
//  Created by Arhan Ashik on 2021/12/02.
//

import SwiftUI

struct GameBoard: View {
    
    init(mode: GameMode) {
            _viewModel = StateObject(wrappedValue: GameViewModel(mode: mode))
    }
    @StateObject private var viewModel: GameViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            MoveIndicatorBackground(proxy: geometry)
                            
                            MoveIndicator(move: viewModel.moves[i])
                        }
                        .onTapGesture { viewModel.processPlayerMove(for: i) }
                    }
                }
                Spacer()
            }
            .navigationTitle(Text(viewModel.mode == .singlePlayer ? "Single Player" : "Multiplayer"))
            .disabled(viewModel.isGameBoradDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() })
                )
            })
        }.navigationTitle(Text("Game"))
    }
}

struct MoveIndicatorBackground: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(.teal)
            .opacity(0.5)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 15)
    }
}

struct MoveIndicator: View {
    var move: Move?
    
    var body: some View {
        Image(systemName: move?.indicator ?? "")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}

struct GameBoard_Previews: PreviewProvider {
    static var previews: some View {
        GameBoard(mode: .singlePlayer)
    }
}
