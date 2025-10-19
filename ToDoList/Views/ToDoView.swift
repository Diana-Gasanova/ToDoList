//
//  ToDoView.swift
//  ToDoList
//
//  Created by Diana G on 19.10.2025.
//

import SwiftUI
import Combine

final class ToDoViewModel: ObservableObject {
    @Published var todo: ToDo

    init(todo: ToDo?) {
        var dateText: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY"
            return dateFormatter.string(from: Date())
        }
        
        
        self.todo = todo ?? ToDo(
            id: Int.random(in: 0...100_000_000),
            todo: "",
            completed: false,
            description: "",
            date: dateText,
            userId: Int.random(in: 0...100_000_000)
        )
    }
}

struct ToDoView: View {
    @StateObject var viewModel: ToDoViewModel

    let completion: (ToDo) -> Void

    init(
        todo: ToDo?,
        completion: @escaping (ToDo) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: ToDoViewModel(todo: todo)
        )

        self.completion = completion
    }

    var body: some View {
        contentView
            .navigationBarBackButtonHidden()
    }

    var contentView: some View {
        VStack(alignment: .leading) {
            Button(
                action: {
                    completion(viewModel.todo)
                },
                label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22))
                            .foregroundStyle(.yellow)
                        Text("Назад")
                            .foregroundStyle(.yellow)
                    }
                }
            )
            TextField(
                text: $viewModel.todo.todo
            ) {
                Text(viewModel.todo.todo)
            }
            .border(.black)
            Text(viewModel.todo.date ?? "--/--/--")
                .border(.black)
            TextField(
                text: Binding(
                    get: { viewModel.todo.description ?? "" },
                    set: { viewModel.todo.description = $0 }
                )
            ) {
                Text(viewModel.todo.description ?? "")
            }
            .border(.black)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}


