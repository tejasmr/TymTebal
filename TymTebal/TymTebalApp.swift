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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
        -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}
