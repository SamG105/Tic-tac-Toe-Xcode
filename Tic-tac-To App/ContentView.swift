//
//  ContentView.swift
//  Tic-tac-To App
//
//  Created by Samuel Guay on 2023-03-09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // basic ai
            GameView()
                .tabItem {
                    Label("DumbAILabel", systemImage: "person.fill.turn.down")
                        .labelStyle(.titleAndIcon)
                }
            //unbeatable
            AIGameBoard()
                .tabItem {
                    Label("AILabel", systemImage: "person.fill")
                        .labelStyle(.titleAndIcon)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
