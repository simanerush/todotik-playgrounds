//
//  EssenceTodo.swift
//  Todotik
//
//  Created by Serafima Nerush on 1/24/22.
//

import SwiftUI

class Todotik: ObservableObject {
    
    let name: String
    
    static func createToDo() -> ToDo {
        ToDo(contents: [ToDo.ToDoObject(content: "Test", date: .now, id: 0)])
    }
    
    @Published private var model: ToDo = createToDo() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "ToDoList:" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(model), forKey: userDefaultsKey)
    }
    
    private func restoreUserDefaults() {
        // Decode from stored JSONData
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedToDo = try? JSONDecoder().decode(ToDo.self, from: jsonData) {
            model = decodedToDo
        }
    }
    
    init(named name: String) {
        self.name = name
        restoreUserDefaults()
    }
    
    var contents: Array<ToDo.ToDoObject> {
        get {
            return model.contents
        } set {
            model.contents = newValue
        }
    }
    
    // MARK: - Intents
    
    func add(_ object: inout ToDo.ToDoObject) {
        model.add(&object)
    }
//
//    func remove(at index: Int) {
//        model.remove(at: index)
//    }
//
    func edit(_ object: ToDo.ToDoObject, newContent: String) {
        model.edit(object: object, newContent: newContent)
    }
    
    func object(at index: Int) -> ToDo.ToDoObject {
        let safeIndex = min(max(index, 0), contents.count - 1)
        return contents[safeIndex]
    }
    
    @discardableResult
    func remove(at index: Int) -> Int {
        if contents.count > 1, contents.indices.contains(index) {
            contents.remove(at: index)
        }
        return index % contents.count
    }
}
