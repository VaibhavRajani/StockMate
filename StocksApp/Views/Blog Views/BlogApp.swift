//
//  BlogApp.swift
//  StocksApp
//
//  Created by Vaibhav on 02/05/23.
//

import SwiftUI
import Firebase

struct BlogApp: App {
    
    //Initializing Firebase...
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene{
        WindowGroup {
            ContentView()
        }
    }
}
