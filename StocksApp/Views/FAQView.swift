//
//  FAQView.swift
//  StocksApp
//
//  Created by Vaibhav on 03/05/23.
//

import SwiftUI
import OpenAISwift

final class ViewModel: ObservableObject{
    init(){}
    
    private var client: OpenAISwift?
    
    func setup(){
        client = OpenAISwift(authToken: "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")
    }
    func send(text: String,
              completion: @escaping (String) -> Void ){
        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case.failure:
                break
            }
        })
    }
}

struct FAQView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                ForEach(models, id: \.self){ string in
                    Text(string)
                }
                
                Spacer()
                
                HStack{
                    TextField("Type here...", text: $text)
                    Button("Send") {
                        send()
                    }
                }
                
            }
            .onAppear{
                viewModel.setup()
            }
            .padding()
        }
    }
        func send(){
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

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}



