//
//  ToDo.swift
//  ToDoList
//
//  Created by Diana G on 19.10.2025.
//

import Foundation

struct ToDo: Decodable, Hashable, Identifiable {
    let id: Int
    var todo: String
    var completed: Bool
    var description: String?
    let date: String?
    let userId: Int

    
}
