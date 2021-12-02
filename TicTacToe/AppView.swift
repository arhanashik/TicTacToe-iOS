//
//  ContentView.swift
//  TicTacToe
//
//  Created by Arhan Ashik on 2021/12/02.
//

import SwiftUI

struct SplashView: View {
     
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: GameBoard(mode: .singlePlayer), label: {
                    Text("Single Player")
                        .frame(width: 200, height: 60)
                        .background(Color.teal)
                        .foregroundColor(.white)
                        .cornerRadius(10.0)
                })
                
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    .resizable()
                    .frame(width: 100, height: 100)
                
                NavigationLink(destination: GameBoard(mode: .multiplayer), label: {
                    Text("Multiplayer")
                        .frame(width: 200, height: 60)
                        .background(Color.teal)
                        .foregroundColor(.white)
                        .cornerRadius(10.0)
                })
            }.offset(y: -60)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
