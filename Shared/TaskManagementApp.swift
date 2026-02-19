//
//  TaskManagementApp.swift
//  TaskManagement
//
//  Created by Kévin PUYJALINET on 16/02/2026.
//

import SwiftUI
import CoreData

@main
struct TaskManagementApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
