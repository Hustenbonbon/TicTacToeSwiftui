//
//  TicTacToeViewModel.swift
//  TicTacToe
//
//  Created by Max Tharr on 20.03.20.
//  Copyright © 2020 Mayflower GmbH. All rights reserved.
//

import Foundation
import Combine

class TicTacToeViewModel: ObservableObject {
    
    var turn = 0
    
    @Published
    var fields = [[FieldContent]](repeating: Array.init(repeating: .empty, count: 3), count: 3)
    
    @Published
    var eingabe = ""
    
    func fieldClicked(column: Int, row: Int) {
        if var field = fields[safe: column]?[safe: row],
            field == .empty {
            field = turn.isMultiple(of: 2) ? FieldContent.X : FieldContent.O
        }
    }
    
    var whoWonPublishers: AnyPublisher<String,Never> {
        $eingabe.map {
            eingabe in
            return eingabe.lowercased()
        }
        .eraseToAnyPublisher()
    }
    
}

enum FieldContent: String {
    case empty
    case X
    case O
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
