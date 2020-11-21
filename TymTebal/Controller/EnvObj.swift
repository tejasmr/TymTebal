//
//  EnvObj.swift
//  TymTebal
//
//  Created by Tejas M R on 21/11/20.
//

import SwiftUI
import CoreData

class EnvObj: ObservableObject {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: [])
    var timeTableItems: FetchedResults<TimeTableItem>
    
    @Published var items: [TimeTableCodeItem]
    
    @Published var editingItem: TimeTableCodeItem
    
    init() {
        self.editingItem = TimeTableCodeItem()
        self.items = []
        timeTableItems.forEach { item in
            self.items.append(TimeTableCodeItem(day: item.day ?? "Mon", time: item.time ?? "8:00", title: item.title ?? "Untitled", content: item.content ?? ""))
        }
    }
    
    func addItem() {
        //        let newItem = TimeTableItem(context: viewContext)
        //        newItem.day = "Mon"
        //        newItem.time = "8:00"
        //        newItem.title = "Untitled"
        //        newItem.content = ""
        //
        //        self.items.append(TimeTableCodeItem(day: "Mon", time: "8:00", title: "Untitled", content: ""))
        //
        //        saveContext()
        
        print("Done")
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
            offsets.map {
                timeTableItems[$0]
            }
            .forEach(viewContext.delete)
            
            saveContext()
        }
    }
    
    func updateItem(_ item: FetchedResults<TimeTableItem>.Element) {
        withAnimation {
            item.day = editingItem.day
            item.time = editingItem.time
            item.title = editingItem.title
            item.content = editingItem.content
            saveContext()
        }
    }
}
