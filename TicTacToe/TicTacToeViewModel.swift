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
    
    var winStreaks = [
        (0, 1, 2),
        (3, 4, 5),
        (6, 7, 8),
        (0, 3, 6),
        (1, 4, 7),
        (2, 5, 8),
        (0, 4, 8),
        (2, 4, 6),
    ]
    
    var turn = 0
    
    @Published
    var fields = [[FieldContent]]()
    
    @Published
    var winnerText = ""
    
    var cancellable: AnyCancellable?
    
    init() {
        self.cancellable = self.whoWonPublishers.assign(to: \.self.winnerText, on: self)
        reset()
    }
    
    func fieldClicked(column: Int, row: Int) {
        if let field = fields[safe: column]?[safe: row],
            field == .empty {
            fields[column][row] = turn.isMultiple(of: 2) ? FieldContent.X : FieldContent.O
            turn += 1
        }
    }
    
    func reset() {
        fields = Array.init(repeating: Array.init(repeating: .empty, count: 3), count: 3)
        winnerText = ""
        turn = 0
    }
    
    var whoWonPublishers: AnyPublisher<String, Never> {
        $fields.compactMap {
            fields in
            
            let flatfields = Array(fields.joined())
            
            for (a,b,c) in self.winStreaks {
                if flatfields[a] == flatfields[b] && flatfields[a] == flatfields[c] {
                    switch(flatfields[a]) {
                        case .empty:
                            break
                        case .X:
                            return "Spieler 1 hat gewonnen!"
                        case .O:
                            return "Spieler 2 hat gewonnen!"
                    }
                }
            }
            return nil
        }
        .eraseToAnyPublisher()
    }
}

enum FieldContent: String {
    case empty = " "
    case X = "🔥"
    case O = "❄️"
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
