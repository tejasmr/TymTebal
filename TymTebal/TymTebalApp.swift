//
//  TymTebalApp.swift
//  TymTebal
//
//  Created by Tejas M R on 21/11/20.
//

import SwiftUI
import CoreData


@main
struct TymTebalApp: App {
    
    let persistenceContainer = PersistenceController.shared
    
    @FetchRequest(sortDescriptors: [])
    var timeTableItems: FetchedResults<TimeTableItem>
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(EnvObj())
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
struct TymTebalApp_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(EnvObj())
            .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
    }
}
