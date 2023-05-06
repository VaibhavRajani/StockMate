//
//  ContentView1.swift
//  StocksApp
//
//  Created by Vaibhav on 03/05/23.
//

import SwiftUI
import OpenAISwift

final class ViewModel: ObservableObject {
    private var client: OpenAISwift?

    func setup() {
        client = OpenAISwift(authToken: "<api_key>")
    }

    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
    }
}

struct ContentView1: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()

    var body: some View {
        VStack(alignment: .center) {
            Text("Ask Me Anything!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)

            Spacer()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(models, id: \.self) { string in
                        Text(string)
                    }

                    Spacer()

                    HStack {
                        TextField("Type here...", text: $text)
                            .padding(.all, 10)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)

                        Button(action: send) {
                            Text("Send")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.teal)

        .onAppear {
            viewModel.setup()
        }
    }

    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        models.append("Me: \(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGPT: " + response)
                self.text = ""
            }
        }
    }
}

struct ContentView1_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}

