//
//  AddToDoView.swift
//  Todotik
//
//  Created by Serafima Nerush on 2/18/22.
//

import SwiftUI
import UserNotifications

struct AddToDoView: View {
    
    @ObservedObject var todoList: Todotik
    @Environment(\.presentationMode) private var presentationMode
    @State private var content = ""
    @State private var date: Date? = nil
    @State private var notificationDate = Date()
    @State private var notificationSectionDisplayed = false
    @State private var notificationAdded = false
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2022, month: 1, day: 1)
        let endComponents = DateComponents(year: 2122, month: 12, day: 31)
        return calendar.date(from:startComponents)!...calendar.date(from:endComponents)!
    }()
    
    func addNewTodo() {
        var newTodo = ToDo.ToDoObject(content: content, date: date, id: 0)
        todoList.add(&newTodo)
        presentationMode.wrappedValue.dismiss()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Todotik all set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        Form {
            nameSection
            dateSection
            submitSection
            notificationButton
            notificationSection
        }
        
    }
    
    var nameSection: some View {
        Section(header: Text("New To-Do")) {
            TextField("Contents", text: $content)
                .modifier(TextFieldClearButton(text: $content))
                .multilineTextAlignment(.leading)
        }
    }
    
    @ViewBuilder
    var dateSection: some View {
        if date != nil {
            HStack {
                
                Section(header: Text("Date Due")) {
                    DatePicker("Date", selection: Binding($date)!, in: dateRange, displayedComponents: [.date])
                }
            }
        } else {
            Button("Add due date") {
                date = .now
            }
        }
    }
    
    var submitSection: some View {
        Button(action: addNewTodo) {
            Text("Add New Todo")
        }
        .disabled(content.isEmpty)
    }
    
    @ViewBuilder
    var notificationButton: some View {
        if !notificationSectionDisplayed {
            Button {
                notificationSectionDisplayed.toggle()
            } label: {
                Text("Add Notification")
            }
        }
        
    }
    
    func addNotification(from notificationDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = self.content
        content.subtitle = "Make Todotik happy!!!"
        content.sound = UNNotificationSound.default
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        let weekday = Calendar.current.component(.weekday, from: notificationDate)
        let hour = Calendar.current.component(.hour, from: notificationDate)
        let minute = Calendar.current.component(.minute, from: notificationDate)
        
        dateComponents.weekday = weekday
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: false)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    @ViewBuilder
    var notificationSection: some View {
        if notificationSectionDisplayed && !notificationAdded{
            VStack {
                DatePicker(
                    "Start Date",
                    selection: $notificationDate,
                    in: dateRange,
                    displayedComponents: [.date, .hourAndMinute]
                )
                Button {
                    addNotification(from: notificationDate)
                    notificationAdded.toggle()
                } label: {
                    Text("Schedule Notification")
                }
            }
 
        } else if notificationAdded {
            Text("Notification Scheduled at \(notificationDate.formatted())")
        }
    }
}

struct AddToDoView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoView(todoList: Todotik(named: "Preview"))
    }
}
