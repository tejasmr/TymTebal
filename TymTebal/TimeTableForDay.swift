//
//  TimeTableForDay.swift
//  TymTebal
//
//  Created by Tejas M R on 21/11/20.
//

import SwiftUI
import CoreData

struct TimeTableForDay: View {
    
    @ObservedObject var envObj: EnvObj
    
    @Binding var day: String
    
    var body: some View {
        List {
            ForEach(self.envObj.items, id:\.self) { item in
                HStack {
                    Spacer()
                    Text(item.time)
                        .foregroundColor(Color.blue)
                    Rectangle()
                        .frame(height: 80.0)
                        .foregroundColor(Color.blue)
                        .cornerRadius(20)
                        .padding(10)
                        .overlay(
                            Text(item.title)
                                .foregroundColor(Color.white)
                        )
                }
            }
        }
    }
}

struct TimeTableCodeItem: Hashable {
    var day: String = "Mon"
    var time: String = "8:00"
    var title: String = "Untitled"
    var content: String = ""
}
