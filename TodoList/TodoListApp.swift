//
//  TodoListApp.swift
//  TodoList
//
//  Created by Selcuk Baki on 25/1/22.
//

import SwiftUI
import Firebase

@main
struct TodoListApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView( buttonChange: false)
        }
    }
}
