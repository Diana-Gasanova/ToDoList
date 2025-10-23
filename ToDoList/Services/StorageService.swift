//
//  StorageService.swift
//  ToDoList
//
//  Created by Diana G on 23.10.2025.
//

import Foundation
import CoreData

protocol StorageServiceDataPassing {
    var taskDownloadedAndSaved: Bool { get }

    func saveTodos(todos: [ToDo])
    func create(_ todo: ToDo)
    func fetchTodos() -> [ToDo]
    func update(todo: ToDo)
    func delete(id: Int64)
}

final class StorageService: StorageServiceDataPassing {
    private let taskDownloadedAndSavedKey = "taskDownloadedAndSavedKey"
    private let userDefault = UserDefaults.standard
    private let context = PersistenceController.shared.context

    var taskDownloadedAndSaved: Bool {
        userDefault.bool(forKey: taskDownloadedAndSavedKey)
    }

    func saveTodos(todos: [ToDo]) {
        todos.forEach { todo in
            create(todo)
        }

        userDefault.setValue(true, forKey: taskDownloadedAndSavedKey)
    }

    func create(_ todo: ToDo) {
        let entity = ToDoE(context: context)
        entity.id = todo.id
        entity.todo = todo.todo
        entity.completed = todo.completed
        entity.descriptions = todo.descriptions
        entity.date = todo.date
        entity.userId = todo.userId

        try? context.save()
    }

    func fetchTodos() -> [ToDo] {
        let request: NSFetchRequest<ToDoE> = ToDoE.fetchRequest()
        let result = (try? context.fetch(request)) ?? []
        return result.map {
            ToDo(
                id: $0.id,
                todo: $0.todo ?? "unknown todo",
                completed: $0.completed,
                descriptions: $0.descriptions ?? "unknown descriptions",
                date: $0.date ?? "unknown date",
                userId: $0.userId
            )
        }
    }

    func update(todo: ToDo) {
        let request: NSFetchRequest<ToDoE> = ToDoE.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", todo.id)
        guard let entity = try? context.fetch(request).first else { return }
        entity.id = todo.id
        entity.todo = todo.todo
        entity.completed = todo.completed
        entity.descriptions = todo.descriptions
        entity.date = todo.date
        entity.userId = todo.userId

        try? context.save()
    }

    func delete(id: Int64) {
        let request: NSFetchRequest<ToDoE> = ToDoE.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", id)
        guard let entity = try? context.fetch(request).first else { return }
        context.delete(entity)
        try? context.save()
    }
}
