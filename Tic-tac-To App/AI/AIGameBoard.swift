//
//  AIGameBoard.swift
//  Tic-tac-To App
//
//  Created by Samuel Guay on 2023-03-08.
//

import SwiftUI

struct AIGameBoard: View {
    @StateObject private var viewModel = AITTT()
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) {i in
                        //GameSquareView(proxy: geometry, postion: i)
                        ZStack{
                            squareBackground(geometry: geometry)
                            
                            Image(systemName: viewModel.currentBoard.position[i].rawValue)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            viewModel.prossesPlayerMove(for: i)
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

struct AIGameBoard_Previews: PreviewProvider {
    static var previews: some View {
        AIGameBoard()
    }
}
