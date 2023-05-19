//
//  Alerts.swift
//  Tic-tac-To App
//
//  Created by Samuel Guay on 2023-03-07.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("AlertHumanTitle"),
                             message: Text("AlertHumanMessage"),
                             buttonTitle: Text("AlertHumanButtonTitle"))
    
    static let computerWin = AlertItem(title: Text("AlertComputerTitle"),
                             message: Text("AlertComputerMessage"),
                             buttonTitle: Text("AlertComputerButtonTitle"))
    
    static let draw = AlertItem(title: Text("AlertDrawTitle"),
                             message: Text("AlertDrawMessage"),
                             buttonTitle: Text("AlertDrawButtonTitle"))
}
