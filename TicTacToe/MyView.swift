//
//  SwiftUIView.swift
//  TicTacToe
//
//  Created by Max Tharr on 13.04.20.
//  Copyright © 2020 Mayflower GmbH. All rights reserved.
//

import Combine
import SwiftUI

struct MyView: View {
    @ObservedObject var viewModel = MyViewModel()
    @State var buttonDisabled = true
    var body: some View {
        VStack {
            TextField("Gib deinen Namen ein", text: $viewModel.textInput)
            Button(action: {
                print("Verschicke Namen")
            }) {
                Text("Zum Chat")
            }
            .disabled(buttonDisabled)
            .onReceive(viewModel.verifiedInput) {
                self.buttonDisabled = !$0
            }
        }
    }
}

class MyViewModel: ObservableObject {
    @Published var textInput = ""
    {
        didSet {
            print("Textinput changed")
        }
    }

    var verifiedInput: AnyPublisher<Bool, Never> {
        $textInput
            .debounce(for: 1, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {
                $0.count >= 3 && $0.first!.isLetter
            }
            .eraseToAnyPublisher()
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
