//
//  AddNewNote.swift
//  TymTebal
//
//  Created by Tejas M R on 22/11/20.
//

import SwiftUI
import Combine
import UserNotifications

struct AddNewNote: View {
    
    @State var day: String = ""
    @State var hour: String = ""
    @State var min: String = ""
    @State var title: String = ""
    
    @State var selected: String = "Mon"
    @Binding var showingAddNewNote: Bool
    @State var isDaily: Bool = false
    
    @Environment(\.managedObjectContext) var viewContext
    
    var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var daysDict = [
        "Sun" : 1,
        "Mon" : 2,
        "Tue" : 3,
        "Wed" : 4,
        "Thu" : 5,
        "Fri" : 6,
        "Sat" : 7
    ]
    
    var body: some View {
        VStack {
            SmallRoundedRectangleThingy()
            
            DaysMenu(color: Color.blue, selected: $selected)
                .padding(.bottom, 15)
            
            HStack(alignment: .center) {
                Toggle(isOn: $isDaily) {
                    Text("Daily")
                        .foregroundColor(Color.black)
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            .padding()

            
            HStack(spacing: 5) {
                Text("Time: ")
                    .frame(width: 50, alignment: .leading)
                TextField("00 (Hour)", text: $hour)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2)
                    )
                    .onReceive(Just(hour)) { val in
                        let filtered = val.filter {
                            "0123456789".contains($0)
                        }
                        if filtered != val {
                            self.hour = filtered
                        }
                        self.hour = String(self.hour.prefix(2))
                        if (stringToInt(self.hour) >= 24) {
                            self.hour = "23"
                        }
                    }
                
                TextField("00 (Min)", text: $min)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2)
                    )
                    .onReceive(Just(min)) { val in
                        let filtered = val.filter {
                            "0123456789".contains($0)
                        }
                        if filtered != val {
                            self.min = filtered
                        }
                        self.min = String(self.min.prefix(2))
                        if (stringToInt(self.min) >= 60) {
                            self.min = "59"
                        }
                    }
            }
            .padding()
            HStack(spacing: 5) {
                Text("Title: ")
                    .frame(width: 50, alignment: .leading)
                TextField("Enter title ", text: $title)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2)
                    )
            }
            .padding()
            
            HStack {
                Button(action: {
                    if (hour != "") {
                        if min != "" && stringToInt(min) <= 9 && min.count < 2 {
                            min = "0" + min
                        }
                        if min == "" {
                            min = "00"
                        }
                        if stringToInt(hour) <= 9 && hour.count < 2{
                            hour = "0" + hour
                        }
                        if title == "" {
                            title = "Untitled"
                        }
                        self.showingAddNewNote.toggle()
                        if self.isDaily {
                            days.forEach { day in
                                addItem(day: day, time: hour+":"+min, title: title, content: "")
                            }
                        }
                        else {
                            addItem(day: selected, time: hour+":"+min, title: title, content: "")
                        }
                        self.hour = ""
                        self.min = ""
                        self.title = ""
                        self.isDaily = false
                    }
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .clipShape(Circle())
                        .padding(.bottom, 10)
                }
                
                Button(action: {
                    self.showingAddNewNote.toggle()
                    self.hour = ""
                    self.min = ""
                    self.title = ""
                    self.isDaily = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .clipShape(Circle())
                        .padding(.bottom, 10)
                }
            }
            
        }
        .padding(.top, 20)
        .background(Color.white)
        .cornerRadius(30, corners: [.topLeft, .topRight])
        .shadow(color: Color.black, radius: 10, x: 0.0, y: 0.0)
    }
    
    func stringToInt(_ string: String) -> Int {
        var intValue = 0
        for i in string {
            intValue = intValue*10 + (Int(i.asciiValue ?? 0) - 48)*10
        }
        return intValue / 10
    }
    
    func addItem(day: String, time: String, title: String, content: String) {
        withAnimation {
            
            let newItem = TimeTableItem(context: viewContext)
            newItem.uuid = UUID()
            newItem.day = day
            newItem.time = time
            newItem.title = title
            newItem.content = content
            
            setNotification(uuid: newItem.uuid ?? UUID(), day: day, time: time, title: title, content: content)
            
            saveContext()
        }
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    func setNotification(uuid: UUID, day: String, time: String, title: String, content: String) {
        
        let center = UNUserNotificationCenter.current()
                
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = content
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        dateComponents.weekday = daysDict[day]
        
        let timeArr = time.split { $0 == ":" }
        dateComponents.hour = stringToInt(String(timeArr[0]))
        dateComponents.minute = stringToInt(String(timeArr[1]))
        print(dateComponents)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = uuid.uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: notificationContent, trigger: trigger)
        
        
        
        center.add(request) { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "No error")
            }
        }
    }
}

