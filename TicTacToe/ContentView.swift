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
    
    @State
    var textcontent = ""
    
    var body: some View {
        VStack {
            ForEach(0...2, id: \.self) {
                column in
                HStack {
                    ForEach(0...2, id: \.self) {
                        row in
                        TicTacToeField(column: column, row: row, content: .constant("O"))
                    }
                }
            }
            Text(viewModel.eingabe)
            TextField("Bla", text: $viewModel.eingabe)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TicTacToeField: View {
    @State
    var column: Int
    
    @State
    var row: Int
    
    @Binding
    var content: String
    
    var body: some View {
        Text(content)
            .font(.title)
            .fontWeight(.bold)
            .frame(width: 100, height: 100, alignment: .center)
            .border(Color.black, width: 5)
    }
}
