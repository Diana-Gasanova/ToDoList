//
//  ListView.swift
//  ToDoList
//
//  Created by Diana G on 15.10.2025.
//

import SwiftUI
import CoreData
import Combine

struct ListView: View {
    @StateObject var viewModel = ListViewModel()

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )

    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            contentView
                .onAppear(perform: viewModel.loadTasks)
        }
        .navigationTitle(Text("Задача"))
        .navigationDestination(
            isPresented: $viewModel.createViewPresented,
            destination: {
                ToDoView(todo: nil) { toDo in
                    viewModel.toDoList.append(toDo)
                    viewModel.createViewPresented = false
                }
            }
        )
        .navigationDestination(
            item: $viewModel.editViewPresented,
            destination: { todoForEdit in
                ToDoView(todo: todoForEdit) { editedTodo in
                    if let index = viewModel.toDoList.firstIndex(where: { $0.id == editedTodo.id }) {
                        viewModel.toDoList[index] = editedTodo
                    }
                    viewModel.editViewPresented = nil
                }
            }
        )
    }

    var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            searchView
                .border(.blue)
            listView
            Spacer()
            bottomView
        }
        .border(.black)
    }

    var searchView: some View {
        TextField(
            text: $viewModel.searchText,
            prompt: Text("Поиск")
        ) {
            Text(viewModel.searchText)
        }
        .frame(height: 36)
        .padding(.horizontal, 5)
        .background(.gray.opacity(0.5))
        .cornerRadius(16)
        .padding(.horizontal, 15)
        .padding(.bottom, 15)
    }

    var listView: some View {
        ScrollView {
            ForEach(viewModel.filteredToDoList) { toDo in
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Image(systemName: toDo.completed ? "checkmark.circle" : "circle")
                            .font(.system(size: 24))
                            .foregroundStyle(toDo.completed ? .yellow : .gray)
                        VStack(alignment: .leading) {
                            Text(toDo.todo)
                                .strikethrough(toDo.completed)
                            Text(toDo.description ?? "-")
                            Text(toDo.date ?? "-")
                        }
                        Spacer()
                    }
                }
                .contextMenu(
                    menuItems: {
                        Button(
                            action: {
                                viewModel.editViewPresented = toDo
                            },
                            label: {
                                Text("Редактировать")
                            }
                        )

                        Button(
                            action: {
                                viewModel.deleteToDo(id: toDo.id)
                            },
                            label: {
                                Text("Удалить")
                                    .foregroundStyle(.red)
                            }
                        )
                    }
                )
            }
        }
        .padding(.horizontal, 20)
    }

    var bottomView: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
                .frame(width: 68, height: 44)
            Spacer()
            Text("\(viewModel.toDoList.count) задач")
            Spacer()
            Button(
                action: {
                    viewModel.createViewPresented = true
                },
                label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 22))
                        .foregroundStyle(.yellow)
                        .frame(width: 68, height: 44)
                }
            )
        }
    }
}

#Preview {
    ListView()
}
