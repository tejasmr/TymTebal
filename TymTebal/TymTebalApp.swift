//
//  TymTebalApp.swift
//  TymTebal
//
//  Created by Tejas M R on 21/11/20.
//

import SwiftUI
import CoreData

let persistenceContainer = PersistenceController.shared

@main
struct TymTebalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(envObj: EnvObj())
        }
    }
}
struct TymTebalApp_Preview: PreviewProvider {
    static var previews: some View {
        ContentView(envObj: EnvObj())
    }
}
