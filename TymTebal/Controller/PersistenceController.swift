//
//  PersistenceController.swift
//  TymTebal
//
//  Created by Tejas M R on 21/11/20.
//

import SwiftUI
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Error: \(error)")
            }
        }
    }
}
