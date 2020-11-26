//
//  DaysMenu.swift
//  TymTebal
//
//  Created by Tejas M R on 22/11/20.
//

import SwiftUI

struct DaysMenu: View {
    
    @State var color: Color
    
    var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    @Binding var selected: String
    
    var gridItemLayout = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 8 - 10, maximum: UIScreen.main.bounds.width / 8)), GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 8 - 10, maximum: UIScreen.main.bounds.width / 8))]
    
    var body: some View {
        HStack(spacing: 9) {
            ForEach(days, id: \.self) { day in
                Button(action: {
                    selected = day
                }) {
                    VStack(spacing: 0) {
                        Text(day)
                            .frame(width: UIScreen.main.bounds.width / 9)
                            .foregroundColor(day == selected ? color : Color.black)
                        
                        if(day == selected) {
                            withAnimation {
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width / 18, height: 2.0)
                            }
                        }
                    }
                }
            }
        }
    }
}


