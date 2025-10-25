//
//  StorageServiceMocks.swift
//  ToDoListTests
//
//  Created by Diana G on 25.10.2025.
//

@testable import ToDoList

final class StorageServiceMocks: StorageServiceDataPassing {
    
    var todos: [ToDo] = []
    var _taskDownloadedAndSaved = false
    
    
    // MARK: StorageServiceDataPassing

    var taskDownloadedAndSaved: Bool { _taskDownloadedAndSaved }

    func saveTodos(todos: [ToDo]) {
        self.todos = todos
    }

    func create(_ todo: ToDo) {
        todos.append(todo)
    }

    func fetchTodos() -> [ToDo] {
        todos
    }

    func update(todo: ToDo) {
        todos = todos.map {
            if $0.id == todo.id {
                todo
            } else {
                $0
            }
        }
    }

    func delete(id: Int64) {
        self.todos = todos.filter { $0.id != id }
    }
}
