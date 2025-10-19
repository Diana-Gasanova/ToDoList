//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Diana G on 15.10.2025.
//

import SwiftUI
import CoreData

@main
struct ToDoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack(
                root: {
                    ListView()
                        .environment(
                            \.managedObjectContext,
                             persistenceController.container.viewContext
                        )
                }
            )
        }
    }
}
