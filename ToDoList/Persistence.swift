//
//  Persistence.swift
//  ToDoList
//
//  Created by Diana G on 15.10.2025.
//

import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
