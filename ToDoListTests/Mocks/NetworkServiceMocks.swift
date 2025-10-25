//
//  NetworkServiceMocks.swift
//  ToDoListTests
//
//  Created by Diana G on 25.10.2025.
//

@testable import ToDoList

final class NetworkServiceMocks: NetworkServiceProtocol {
    var todos: [ToDo] = []

    func fetchTodos() async -> [ToDo] {
        todos
    }
}
