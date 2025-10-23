//
//  ToDo.swift
//  ToDoList
//
//  Created by Diana G on 19.10.2025.
//

import Foundation

struct ToDo: Decodable, Hashable, Identifiable {
    let id: Int64
    var todo: String
    var completed: Bool
    var descriptions: String
    let date: String
    let userId: Int64

    init(id: Int64, todo: String, completed: Bool, descriptions: String, date: String, userId: Int64) {
        self.id = id
        self.todo = todo
        self.completed = completed
        self.descriptions = descriptions
        self.date = date
        self.userId = userId
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.todo = try container.decode(String.self, forKey: .todo)
        self.completed = try container.decode(Bool.self, forKey: .completed)
        self.descriptions = (try? container.decodeIfPresent(String.self, forKey: .description)) ?? "-"
        self.date = (try? container.decodeIfPresent(String.self, forKey: .date)) ?? "--/--/--"
        self.userId = try container.decode(Int64.self, forKey: .userId)
    }

    enum CodingKeys: CodingKey {
        case id
        case todo
        case completed
        case description
        case date
        case userId
    }
}
