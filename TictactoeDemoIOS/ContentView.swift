//
//  ContentView.swift
//  TictactoeDemoIOS
//
//  Created by Max Tharr on 19.05.20.
//  Copyright © 2020 Mayflower GmbH. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var aniTest = false
    
    var body: some View {
        VStack(spacing: 100) {
            VStack {
                ForEach(0 ... 2, id: \.self) { column in
                    HStack(spacing: 0.0) {
                        ForEach(0 ... 2, id: \.self) { row in
                            Tile(content: self.$viewModel.fields[column][row])
                                .onTapGesture{
                                    self.viewModel.fieldTapped(column: column, row: row)}
                        }
                    }
                }
            }
            Text(viewModel.winnerText).largeTitle()
            Text(viewModel.player1).font(.title).offset(y: aniTest ? -30 : 30).animation(.easeInOut)
            if viewModel.winnerText != "Spielt weiter!" {
                Button(action: {
                    self.viewModel.reset()
                }, label: {
                    Text("resetText")
                })
            }
            Button(action: {
                withAnimation {
                    self.aniTest.toggle()
                }
            }, label: {
                Text("Click")
            })
        }
    }
    
    func fieldTapped(column: Int, row: Int) {
        self.viewModel.fieldTapped(column: column, row: row)
    }
}

extension View {
    func largeTitle() -> some View {
        return self.font(.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Tile: View {
    @Binding var content: String
    
    var body: some View {
        Text(content)
            .font(.largeTitle)
            .frame(width: 100, height: 100, alignment: .center)
            .border(Color.black)
            .background(Color.white)
    }
}

class ViewModel: ObservableObject {
    let player1 = "🚀"
    let player2 = "🌴"
    
    
    
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
    
    @Published var turnOrder: Bool = false
    
    @Published var fields: [[String]] = .init(repeating: .init(repeating: "", count: 3), count: 3)
    
    @Published var winnerText: LocalizedStringKey = ""
    
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = whoWonPublisher.assign(to: \.winnerText, on: self)
    }
    
    func fieldTapped(column: Int, row: Int) {
        fields[column][row] = turnOrder ? player2 : player1
        withAnimation {
            turnOrder.toggle()
        }
    }
    
    var whoWonPublisher: AnyPublisher<LocalizedStringKey,Never> {
        $fields.map { fields in
            let flatFields = Array(fields.joined())
            
            for (a, b, c) in self.winStreaks {
                if flatFields[a] == flatFields[b] && flatFields[a] == flatFields[c] {
                    switch flatFields[a] {
                        case self.player1:
                            return "wintext"
                        case self.player2:
                        return "Spieler \(self.player2) hat gewonnen!"
                        default:
                        return "Spielt weiter!"
                    }
                }
            }
            return "Spielt weiter!"
        }.eraseToAnyPublisher()
    }
    
    
    func reset() {
        fields = .init(repeating: .init(repeating: "", count: 3), count: 3)
        winnerText = "Spielt weiter!"
        turnOrder = false
    }
}
