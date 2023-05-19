//
//  GameView.swift
//  Tic-tac-To App
//
//  Created by Samuel Guay on 2023-03-07.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) {i in
                        //GameSquareView(proxy: geometry, postion: i)
                        ZStack{
                            squareBackground(geometry: geometry)
                            
                            Image(systemName: viewModel.moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem){ alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: viewModel.resetGame))
            }
        }
    }
    
    
}
struct squareBackground: View {
    @StateObject private var viewModel = GameViewModel()
    var geometry: GeometryProxy
    
    var body: some View {
        Rectangle()
            .cornerRadius(45)
            .foregroundColor(viewModel.buttonColor).opacity(0.6)
            .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

