//
//  ContentView.swift
//  TicTacToe
//
//  Created by Max Tharr on 20.03.20.
//  Copyright © 2020 Mayflower GmbH. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject
    var viewModel = TicTacToeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            ForEach(0...2, id: \.self) {
                column in
                HStack(spacing: 0) {
                    ForEach(0...2, id: \.self) {
                        row in
                        TicTacToeField(content: self.$viewModel.fields[column][row])
                            .onTapGesture {
                                self.viewModel.fieldClicked(column: column, row: row)
                        }
                    }
                }
            }
            Text(viewModel.winnerText)
                .foregroundColor(Color.red)
                .font(.title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TicTacToeField: View {
    @Binding
    var content: FieldContent
    
    var body: some View {
        Text("\(content.rawValue)")
            .font(.title)
            .fontWeight(.bold)
            .frame(width: 100, height: 100, alignment: .center)
            .border(Color.black, width: 3)
    }
}
