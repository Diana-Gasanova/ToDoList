//
//  NetworkService.swift
//  ToDoList
//
//  Created by Diana G on 25.10.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchTodos() async -> [ToDo]
}

final class NetworkService: NetworkServiceProtocol {
    func fetchTodos() async -> [ToDo] {
        guard
            let url = URL(string: "https://dummyjson.com/todos"),
            let (data, response) = try? await URLSession.shared.data(from: url),
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200,
            let decoded = try? JSONDecoder().decode(TodoResponse.self, from: data)
        else {
            return []
        }

        return decoded.todos
    }
}
