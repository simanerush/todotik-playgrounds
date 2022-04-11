//
//  TodotikApp.swift
//  Todotik
//
//  Created by Serafima Nerush on 1/22/22.
//

import SwiftUI

@main
struct TodotikApp: App {
    let todo = Todotik(named: "To Do Name")
    var body: some Scene {
        WindowGroup {
            TodotikView(toDoList: todo)
        }
    }
}
