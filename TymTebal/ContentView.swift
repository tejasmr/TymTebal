//
//  ContentView.swift
//  TymTebal
//
//  Created by Tejas M R on 21/11/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var envObj: EnvObj
    
    var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    @State var selected: String = "Mon"
    
    var gridItemLayout = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 8 - 10, maximum: UIScreen.main.bounds.width / 8)), GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 8 - 10, maximum: UIScreen.main.bounds.width / 8))]
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 9) {
                    ForEach(days, id: \.self) { day in
                        Button(action: {
                            selected = day
                        }) {
                            VStack(spacing: 0) {
                                Text(day)
                                    .frame(width: UIScreen.main.bounds.width / 9)
                                    .foregroundColor(day == selected ? Color.blue : Color.black)
                                
                                if(day == selected) {
                                    Rectangle()
                                        .frame(width: UIScreen.main.bounds.width / 18, height: 2.0)
                                }
                            }
                        }
                    }
                }
                Spacer()
                TimeTableForDay(envObj: envObj, day: $selected)
                Spacer()
            }
            
            VStack {
                Spacer()
                Button(action: {
                    print("Done")
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .clipShape(Circle())
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding(.bottom, 5)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(envObj: EnvObj())
    }
}
