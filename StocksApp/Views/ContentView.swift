//
//  ContentView.swift
//  StocksApp
//
//  Created by Vaibhav on 02/05/23.
//

import SwiftUI
import FirebaseCore

struct ContentView: View {
    var body: some View {
        NavigationView{
            Home()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
