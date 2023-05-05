//
//  ChatApp.swift
//  StocksApp
//
//  Created by Vaibhav on 03/05/23.
//

import SwiftUI
import ChatGPTSwift

struct ChatGPTApp: App {
    
    @StateObject var vm = ViewModel1(api: ChatGPTAPI(apiKey: "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"))
    @State var isShowingTokenizer = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView1(vm: vm)
                    .toolbar {
                        ToolbarItem {
                            Button("Clear") {
                                vm.clearMessages()
                            }
                            .disabled(vm.isInteractingWithChatGPT)
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Tokenizer") {
                                self.isShowingTokenizer = true
                            }
                            .disabled(vm.isInteractingWithChatGPT)
                        }
                    }
            }
            .fullScreenCover(isPresented: $isShowingTokenizer) {
                NavigationTokenView()
            }
        }
    }
}


struct NavigationTokenView: View {
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            TokenizerView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
        }
        .interactiveDismissDisabled()
    }
}
