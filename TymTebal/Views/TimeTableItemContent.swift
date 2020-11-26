//
//  TimeTableItemContent.swift
//  TymTebal
//
//  Created by Tejas M R on 22/11/20.
//

import SwiftUI
import Combine

struct TimeTableItemContent: View {
    @State var selected: String
    @State var title: String
    @State var hour: String
    @State var min: String
    
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentation
    
    @State var item: FetchedResults<TimeTableItem>.Element
    
    var body: some View {
        
        VStack {
            DaysMenu(color: Color.blue, selected: $selected)
                .padding(.vertical, 15)
            
            

            
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
            
            Spacer()
            
            Button(action: {
                self.presentation.wrappedValue.dismiss()
                updateItem(item)
            }) {
                Image(systemName: "square.and.arrow.down")
                    .resizable()
                    .font(.system(.title))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 13)
                    .frame(width: 50, height: 50, alignment: .center)
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .clipShape(Circle())
                    .padding(.bottom, 10)
            }
        }

    }
    
    func stringToInt(_ string: String) -> Int {
        var intValue = 0
        for i in string {
            intValue = intValue*10 + (Int(i.asciiValue ?? 0) - 48)*10
        }
        return intValue / 10
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    func updateItem(_ item: FetchedResults<TimeTableItem>.Element) {
        withAnimation {
            item.title = title
            item.time = hour + ":" + min
            item.day = selected
            saveContext()
        }
    }
}

