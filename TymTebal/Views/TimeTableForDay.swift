//
//  TimeTableForDay.swift
//  TymTebal
//
//  Created by Tejas M R on 21/11/20.
//

import SwiftUI
import CoreData

struct TimeTableForDay: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "time", ascending: true)])
    var timeTableItems: FetchedResults<TimeTableItem>
    
    @EnvironmentObject var envObj: EnvObj
    
    @Binding var day: String
    
    var body: some View {
        List {
            ForEach(timeTableItems) { item in
                if day == item.day {
                    NavigationLink(destination: TimeTableItemContent(selected: item.day ?? "Mon", title: item.title ?? "Untitled", hour: String((item.time ?? "00:00").split { $0 == ":" }[0]), min: String((item.time ?? "00:00").split { $0 == ":" }[1]), item: item)
                                    .navigationBarTitle(item.title ?? "Untitled", displayMode: .inline)) {
                        HStack {
                            Text(item.time ?? "8:00")
                                .foregroundColor(Color.blue)
                            Spacer()
                            Rectangle()
                                .frame(height: 50.0)
                                .foregroundColor(Color.blue)
                                .cornerRadius(20)
                                .overlay(
                                    Text(item.title ?? "Untitled")
                                        .foregroundColor(Color.white)
                                        .lineLimit(1)
                                        .padding(.horizontal, 5)
                                )
                        }
                    }
                }
                
                
            }.onDelete(perform: deleteItem)
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
    
    func deleteItem(offsets: IndexSet) {
        withAnimation {
            
            offsets.forEach {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(timeTableItems[$0].uuid ?? UUID()).uuidString])
            }
            offsets.map {
                timeTableItems[$0]
            }
            .forEach(viewContext.delete)

            
            saveContext()
        }
    }
}

struct TimeTableCodeItem: Hashable {
    var uuid: UUID = UUID()
    var day: String = "Mon"
    var time: String = "8:00"
    var title: String = "Untitled"
    var content: String = ""
}
