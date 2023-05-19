//
//  AISolver.swift
//  Tic-tac-To App
//
//  Created by Samuel Guay on 2023-03-08.
//

import SwiftUI

final class AIViewModel: ObservableObject {
    @Published var currentBoard: board = board()
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var buttonColor: Color = .accentColor
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    @Published var AITrainingProgress:Double = 0
    private var knowWinningMoves: Set<Set<Int>> = []
    
    func po() {
        
    }
    //private var knowLosingMoves: Set<board> = []

    func onWin(for player: Player) {
        switch player {
        case.computer:
            let arrayOfComputerMoves = currentBoard.squares.compactMap {$0}.filter {$0.player == .computer}
            let arrayOfComputerPositions = Set(arrayOfComputerMoves.map {$0.boardIndex})
            knowWinningMoves.insert(arrayOfComputerPositions)
            break
        case.human:
            let arrayOfHumanMoves = currentBoard.squares.compactMap {$0}.filter {$0.player == .human}
            let arrayOfHumanPositions = Set(arrayOfHumanMoves.map {$0.boardIndex})
            knowWinningMoves.insert(arrayOfHumanPositions)
            break
        }
    }
    
    func trainAI() {
        var temporaryBoard = board()
        
        for progress in 0..<1000 {
            AITrainingProgress = Double(progress)
            
            let computer1Position = determineComputerMove(in: temporaryBoard.squares)
            temporaryBoard.squares[computer1Position] = move(player: .human, boardIndex: computer1Position)
            temporaryBoard.lastComputerMove = move(player: .human, boardIndex: computer1Position)
            //isGameBoardDisabled = false
            temporaryBoard.lastComputerMove = move(player: .human, boardIndex: computer1Position)
            
            if checkWinCondition(for: .human, in: temporaryBoard.squares){
                onWin(for: .human)
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: temporaryBoard.squares){
                alertItem = AlertContext.draw
                return
            }
            let computer2Position = determineComputerMove(in: temporaryBoard.squares)
            temporaryBoard.squares[computer2Position] = move(player: .computer, boardIndex: computer2Position)
            temporaryBoard.lastComputerMove = move(player: .computer, boardIndex: computer2Position)
            //isGameBoardDisabled = false
            temporaryBoard.lastComputerMove = move(player: .computer, boardIndex: computer2Position)
            
            if checkWinCondition(for: .computer, in: temporaryBoard.squares){
                onWin(for: .computer)
                //alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: temporaryBoard.squares){
                //alertItem = AlertContext.draw
                return
            }
        }
        AITrainingProgress = 0
    }
    
    func processPlayerMove(for i: Int) {
        if isSquareOccupied(in: currentBoard.squares, forIndex: i) { return }
        currentBoard.squares[i] = move( player: .human, boardIndex: i)
        currentBoard.lastHumanMove = move(player: .human, boardIndex: i)
        currentBoard.lastHumanMove = move(player: .human, boardIndex: i)
        
        
        if checkWinCondition(for: .human, in: currentBoard.squares){
            onWin(for: .human)
            alertItem = AlertContext.humanWin
            return
        }
        if checkForDraw(in: currentBoard.squares){
            alertItem = AlertContext.draw
            return
        }
        isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){ [self] in
            let computerPosition = determineComputerMove(in: currentBoard.squares)
            currentBoard.squares[computerPosition] = move(player: .computer, boardIndex: computerPosition)
            currentBoard.lastComputerMove = move(player: .computer, boardIndex: computerPosition)
            isGameBoardDisabled = false
            currentBoard.lastComputerMove = move(player: .computer, boardIndex: computerPosition)
            
            if checkWinCondition(for: .computer, in: currentBoard.squares){
                onWin(for: .computer)
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: currentBoard.squares){
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    private func isSquareOccupied(in moves: [move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    private func determineComputerMove(in moves: [move?]) -> Int {
        let currentComputerMoves = moves.compactMap {$0}.filter {$0.player == .computer}
        let currentHumanMoves = moves.compactMap {$0}.filter {$0.player == .human}
        
        if currentComputerMoves.count > 2 {
            for pattern in knowWinningMoves {
                let computerPositions = Array(currentComputerMoves.map { $0.boardIndex })
                let humanPositions = Array(currentHumanMoves.map {$0.boardIndex })
                
                if pattern.contains(computerPositions[0]) && pattern.contains(computerPositions[1]) || pattern.contains(computerPositions[0]) && pattern.contains(computerPositions[2]) || pattern.contains(computerPositions[1]) && pattern.contains(computerPositions[2]) {
                    for num in pattern {
                        if !isSquareOccupied(in: currentBoard.squares, forIndex: num){
                            return num
                            
                        }
                    }
                } else if pattern.contains(humanPositions[0]) && pattern.contains(humanPositions[1]) || pattern.contains(humanPositions[0]) && pattern.contains(humanPositions[2]) || pattern.contains(humanPositions[1]) && pattern.contains(humanPositions[2]) {
                    for num in pattern {
                        if !isSquareOccupied(in: currentBoard.squares, forIndex: num){
                            return num
                            
                        }
                    }
                }
                
            }
        }
        
        //for board in knowLosingMoves where board.squares == currentBoard.squares {return true}
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: currentBoard.squares, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
        
    }
    
    private func checkWinCondition(for player: Player, in moves: [move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {return true}
        
        return false
    }
    
    private func checkForDraw(in moves: [move?]) -> Bool{
        return moves.compactMap {$0}.count == 9
    }
    
    func resetGame() {
        currentBoard = board()
        
    }
    
    struct board: Equatable {
        static func == (lhs: AIViewModel.board, rhs: AIViewModel.board) -> Bool {
            lhs.squares == rhs.squares
        }
        
        var squares: [move?] = Array(repeating: nil, count: 9)
        
        var lastComputerMove: move?
        var lastHumanMove: move?
        
        var boardBeforeLastComputerMove: [move?] {
            var array: [move?] = squares
            array.remove(at: lastComputerMove?.boardIndex ?? 10)
            return array
        }
        var boardBeforeLastHumanMove: [move?] {
            var array: [move?] = squares
            array.remove(at: lastComputerMove?.boardIndex ?? 10)
            array.remove(at: lastHumanMove?.boardIndex ?? 10)
            return array
        }
    }
    
    enum Player {
        case human, computer//, free
    }
    
    struct move: Identifiable, Equatable {
        var player: Player
        var boardIndex: Int
        var id: Int {
            boardIndex
        }
        
        var indicator: String {
            switch player{
            case.computer:
                return "circle"
            case .human:
                return "xmark"
                
            }
        }
    }
}

///  mark: hello
final class AITTT: ObservableObject {
    @Published var currentBoard = Board()
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var buttonColor: Color = .accentColor
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    enum Piece: String {
        case X = "xmark"
        case O = "circle"
        case E = ""
        var opposite: Piece {
            switch self {
            case .X:
                return .O
            case .O:
                return .X
            case .E:
                return .E
            }
        }
    }
    typealias Move = Int
    struct Board {
        let position: [Piece]
        let turn: Piece
        let lastMove: Move
        
        init(position: [Piece] = [.E, .E, .E, .E, .E, .E, .E, .E, .E], turn: Piece = .X, lastMove: Int = -1) {
            self.position = position
            self.turn = turn
            self.lastMove = lastMove
        }
        // location can be 0-8, indicating where to move
        // return a new board with the move played
        func move(_ location: Move) -> Board {
            var tempPosition = position
            tempPosition[location] = turn
            return Board(position: tempPosition, turn: turn.opposite, lastMove: location)
        }
        var legalMoves: [Move] {
            return position.indices.filter { position[$0] == .E }
        }
        var isWin: Bool {
            
            return position[0] == position[1] && position[0] == position[2] && position[0] != .E || // row 0
            position[3] == position[4] && position[3] == position[5] && position[3] != .E || // row 1
            position[6] == position[7] && position[6] == position[8] && position[6] != .E || // row 2
            position[0] == position[3] && position[0] == position[6] && position[0] != .E || // col 0
            position[1] == position[4] && position[1] == position[7] && position[1] != .E || // col 1
            position[2] == position[5] && position[2] == position[8] && position[2] != .E || // col 2
            position[0] == position[4] && position[0] == position[8] && position[0] != .E || // diag 0
            position[2] == position[4] && position[2] == position[6] && position[2] != .E // diag 1
            
        }
        var isDraw: Bool {
            return !isWin && legalMoves.count == 0
        }
    }
    
    func minimax(_ board: Board, maximizing: Bool, originalPlayer: Piece) -> Int {
        // Base case - evaluate the position if it is a win or a draw
        if board.isWin && originalPlayer == board.turn.opposite { return 1 } // win
        else if board.isWin && originalPlayer != board.turn.opposite { return -1 } // loss
        else if board.isDraw { return 0 } // draw
        
        // Recursive case - maximize your gains or minimize the opponent's gains
        if maximizing {
            var bestEval = Int.min
            for move in board.legalMoves { // find the move with the highest evaluation
                let result = minimax(board.move(move), maximizing: false, originalPlayer: originalPlayer)
                bestEval = max(result, bestEval)
            }
            return bestEval
        } else { // minimizing
            var worstEval = Int.max
            for move in board.legalMoves {
                let result = minimax(board.move(move), maximizing: true, originalPlayer: originalPlayer)
                worstEval = min(result, worstEval)
            }
            return worstEval
        }
    }
    func findBestMove(_ board: Board) -> Move {
        var bestEval = Int.min
        var bestMove = -1
        for move in board.legalMoves {
            let result = minimax(board.move(move), maximizing: false, originalPlayer: board.turn)
            if result > bestEval {
                bestEval = result
                bestMove = move
            }
        }
        return bestMove
    }
    
    func isSquareOccupied(in board: Board, forIndex index: Int) -> Bool {
        //return moves.contains(where: { $0?.boardIndex == index })
        return board.position[index] != .E
    }
    
    func prossesPlayerMove(for place: Int) {
        if isSquareOccupied(in: currentBoard, forIndex: place) {return}
        currentBoard = currentBoard.move(place)
        
        if currentBoard.isWin {
            alertItem = AlertContext.humanWin
            return
        } else if currentBoard.isDraw {
            alertItem = AlertContext.draw
            return
        }
        isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            let bestMove = findBestMove(currentBoard)
            
            currentBoard = currentBoard.move(bestMove)
            
            if currentBoard.isWin {
                alertItem = AlertContext.computerWin
                return
            } else if currentBoard.isDraw {
                alertItem = AlertContext.draw
                return
            }
            isGameBoardDisabled = false
        }
    }
    func resetGame() {
        currentBoard = Board()
        isGameBoardDisabled = false
    }
}
