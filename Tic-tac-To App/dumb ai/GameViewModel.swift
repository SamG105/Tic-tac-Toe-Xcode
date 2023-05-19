//
//  GameViewModel.swift
//  Tic-tac-To App
//
//  Created by Samuel Guay on 2023-03-07.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var buttonColor: Color = .accentColor
    @Published var moves: [move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for i: Int) {
        if isSquareOccupied(in: moves, forIndex: i) { return }
        moves[i] = move(player: .human, boardIndex: i)
        
        
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            return
        }
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            let computerPosition = determineComputerMove(in: moves)
            moves[computerPosition] = move(player: .computer, boardIndex: computerPosition)
            isGameBoardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves){
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMove(in moves: [move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
        
    }
    
    func checkWinCondition(for player: Player, in moves: [move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {return true}
        
        return false
    }
    
    func checkForDraw(in moves: [move?]) -> Bool{
        return moves.compactMap {$0}.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        
    }
    enum Player {
        case human, computer
    }

    struct move {
        var player: Player
        var boardIndex: Int
        
        var indicator: String {
            return player == .human ? "xmark" : "circle"
        }
    }
    
}

