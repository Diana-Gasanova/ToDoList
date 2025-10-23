//
//  ListViewModel.swift
//  ToDoList
//
//  Created by Diana G on 19.10.2025.
//

import Combine
import Foundation

struct TodoResponse: Decodable {
    let todos: [ToDo]
}

final class ListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var createViewPresented = false
    @Published var isShareSheetPresented = false
    @Published var editViewPresented: ToDo?
    @Published var toDoList: [ToDo] = []

    var filteredToDoList: [ToDo] {
        guard !searchText.isEmpty else { return toDoList }
        return toDoList.filter { $0.todo.contains(searchText) }
    }

    private let storageService: StorageServiceDataPassing = StorageService()
    private var toTosDownloaded = false

    func loadTasks() {
        guard !toTosDownloaded else { return }
        toTosDownloaded = true

        guard
            storageService.taskDownloadedAndSaved == false,
            let url = URL(string: "https://dummyjson.com/todos")
        else {
            toDoList = storageService.fetchTodos()
            return
        }
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return}

                let decoded = try JSONDecoder().decode(TodoResponse.self, from: data)
                toDoList = decoded.todos
                storageService.saveTodos(todos: decoded.todos)
            } catch {
                //
            }
        }
    }

    func create(todo: ToDo) {
        toDoList.append(todo)
        createViewPresented = false
        DispatchQueue.global(qos: .background).async {
            self.storageService.create(todo)
        }
    }

    func update(todo: ToDo) {
        if let index = toDoList.firstIndex(where: { $0.id == todo.id }) {
            toDoList[index] = todo
        }
        editViewPresented = nil

        DispatchQueue.global(qos: .background).async {
            self.storageService.update(todo: todo)
        }
    }
    
    func deleteToDo(id: Int64) {
        toDoList = toDoList.filter { $0.id != id }
        DispatchQueue.global(qos: .background).async {
            self.storageService.delete(id: id)
        }
    }

    func toggleCompletion(for todo: ToDo) {
        // Находим индекс в списке
        guard let index = toDoList.firstIndex(where: { $0.id == todo.id }) else { return }

        // Переключаем состояние
        toDoList[index].completed.toggle()

        // Обновляем Core Data
        DispatchQueue.global(qos: .background).async {
            self.storageService.update(todo: self.toDoList[index])
        }

        // Обновляем UI
        objectWillChange.send()
    }
    
}
