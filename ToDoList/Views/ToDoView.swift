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
            id: Int64.random(in: 0...100_000_000),
            todo: "",
            completed: false,
            descriptions: "",
            date: dateText,
            userId: Int64.random(in: 0...100_000_000)
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
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
    }
    
    var contentView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Button(
                        action: {
                            completion(viewModel.todo)
                        },
                        label: {
                            Image(systemName: "chevron.left")
                                .bold()
                                .font(.system(size: 22))
                                .foregroundStyle(.yellow)
                            Text("Назад")
                                .foregroundStyle(.yellow)
                                .font(.headline)
                        }
                    )
                    Spacer()
                }
                .padding(.top, 5)
                .padding(.horizontal, 7)

                TextEditor(text: $viewModel.todo.todo)
                    .frame(minHeight: 100)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                
                Text(viewModel.todo.date)
                    .padding(.leading, 5)
                    .padding(.vertical, 10)
                
                TextEditor(text: $viewModel.todo.descriptions)
                    .frame(minHeight: 100)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .keyboardType(.namePhonePad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
            Spacer()
        }
    }
}



#Preview("Превью с реальными данными из API") {
    AsyncPreview()
}

struct AsyncPreview: View {
    @State private var todo: ToDo? = nil

    var body: some View {
        Group {
            if let todo = todo {
                NavigationView {
                    ToDoView(todo: todo) { _ in }
                }
            } else {
                ProgressView("Загрузка...")
                    .task {
                        await loadTodo()
                    }
            }
        }
    }

    func loadTodo() async {
        guard let url = URL(string: "https://dummyjson.com/todos/1") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(ToDo.self, from: data)
            await MainActor.run {
                todo = decoded
            }
        } catch {
            print("Ошибка загрузки превью: \(error)")
        }
    }
}
