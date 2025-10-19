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
    @Published var editViewPresented: ToDo?
    @Published var toDoList: [ToDo] = []

    var filteredToDoList: [ToDo] {
        guard !searchText.isEmpty else { return toDoList }
        return toDoList.filter { $0.todo.contains(searchText) }
    }

    private var toTosDownloaded = false

    func loadTasks() {
        guard !toTosDownloaded, let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return}

                let decoded = try JSONDecoder().decode(TodoResponse.self, from: data)
                toDoList = decoded.todos
            } catch {
                //
            }

            toTosDownloaded = true
        }
    }

    func deleteToDo(id: Int) {
        toDoList = toDoList.filter { $0.id != id }
    }
}
