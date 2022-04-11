//
//  TodotikView.swift
//  Todotik
//
//  Created by Serafima Nerush on 1/22/22.
//

import SwiftUI
import UserNotifications

struct TodotikView: View {
    
    @ObservedObject var toDoList: Todotik
    @State private var showingSheet = false
    
    init(toDoList: Todotik) {
        //Use this if NavigationBarTitle is with Large Font
//        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "FiraCode-Bold", size: 40)!]
        
        self.toDoList = toDoList
        //Use this if NavigationBarTitle is with displayMode = .inline
        //UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach($toDoList.contents) { $object in
                    NavigationLink(destination: ToDoObjectEditor(objectToEdit: $object).navigationBarTitle("", displayMode: .inline)) {
                        VStack(alignment: .leading) {
                            Text(object.content)
                            Text(object.dateFormatted()).foregroundColor(.gray)
                        }.font(FontAshot.commonFont(fontSize: 16))
                    }
                }
                .onDelete { indexSet in
                    toDoList.contents.remove(atOffsets: indexSet)
                }
                
            }
            .navigationBarTitle(Text(toDoList.name).font(.subheadline))
            .toolbar {
                Button {
                    showingSheet.toggle()
                    } label: {
                        Label("New", systemImage: "plus")
                    }
                    .sheet(isPresented: $showingSheet) {
                        AddToDoView(todoList: toDoList)
                    }
                }
        }
        
    }
    
    struct ToDoObjectEditor: View {
        
        @Binding var objectToEdit: ToDo.ToDoObject
        
        var body: some View {
            Form {
                nameSection
                dateSection
            }
            
        }
        
        var nameSection: some View {
            Section(header: Text("New To-Do")) {
                TextField("Contents", text: $objectToEdit.content)
                    .modifier(TextFieldClearButton(text: $objectToEdit.content))
                    .multilineTextAlignment(.leading)
            }
        }
        
        @ViewBuilder
        var dateSection: some View {
            if objectToEdit.date != nil {
                HStack {
                    Section(header: Text("Date Due")) {
                        DatePicker("Date", selection: Binding($objectToEdit.date)!, displayedComponents: [.date])
                    }
                    Button {
                        objectToEdit.date = nil
                    } label: {
                        Image(systemName: "minus.circle.fill").foregroundColor(.accentColor)
                    }
                }
            } else {
                Button("Add due date") {
                    objectToEdit.date = .now
                }
            }
        }
    }
}



struct TodotikView_Previews: PreviewProvider {
    static var previews: some View {
        TodotikView(toDoList: Todotik(named: "Preview"))
    }
}

