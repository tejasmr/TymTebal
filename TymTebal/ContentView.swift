//
//  ContentView.swift
//  TymTebal
//
//  Created by Tejas M R on 21/11/20.
//

import SwiftUI
import CoreData

let persistenceContainer = PersistenceController.shared

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
        
    @EnvironmentObject var envObj: EnvObj
    
    @State var selected: String = "Mon"
    
    @State var showingAddNewNote: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    DaysMenu(color: Color.blue, selected: $selected)
                    
                    Spacer()
                    TimeTableForDay(day: $selected)
                    Spacer()
                }
                
                ZStack {
                    VStack {
                        Spacer()
                        AddNewNote(showingAddNewNote: $showingAddNewNote)
                            .rotation3DEffect(
                                Angle.degrees(self.showingAddNewNote ? 0 : 180),
                                axis: (x: 1, y: 0, z: 1)
                            )
                            .animation(Animation.default)
                            .offset(x: CGFloat(0.0), y: self.showingAddNewNote ? CGFloat(0.0) : CGFloat(UIScreen.main.bounds.size.height))
                            
                    }
                    if (!self.showingAddNewNote) {
                        VStack {
                            Spacer()
                            Button(action: {
                                self.showingAddNewNote.toggle()
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
            }.navigationBarHidden(true)
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(EnvObj())
            .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
    }
}
