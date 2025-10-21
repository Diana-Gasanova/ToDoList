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
    @State private var isShareSheetPresented = false
    
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
                .navigationTitle(Text("Задачи"))
        }
        
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
        VStack(alignment: .center) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    searchView
                    listView
                        .padding(.bottom, 80)
                }
            }
                bottomView
            }
        
        }
    
    
    
    var searchView: some View {
        TextField("Search", text: $viewModel.searchText)
            .padding(.vertical, 8)
            .padding(.horizontal, 36)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(10)
            .overlay {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Image(systemName: "mic.fill")
                        .foregroundStyle(.gray)
                        .padding(.trailing, 10)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
    }
    
    var listView: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.filteredToDoList) { toDo in
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Image(systemName: toDo.completed ? "checkmark.circle" : "circle")
                            .font(.system(size: 24))
                            .foregroundStyle(toDo.completed ? .yellow : .gray)
                        
                        VStack(alignment: .leading) {
                            Text(toDo.todo)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .strikethrough(toDo.completed)
                            Text(toDo.description ?? "-")
                            Text(toDo.date ?? "-")
                        }
                    }
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.vertical, 4)
                }
                .padding(.horizontal, 20)
                .onTapGesture {
                    viewModel.editViewPresented = toDo
                }
                .contextMenu {
                    Button {
                        viewModel.editViewPresented = toDo
                    } label: {
                        Label("Редактировать", systemImage: "square.and.pencil")
                    }
                    
                    Button {
                        // shareSheet
                    } label: {
                        Label("Поделиться", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(role: .destructive) {
                        viewModel.deleteToDo(id: toDo.id)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    
    var bottomView: some View {
        ZStack {
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
            .background(Color.gray)
        }
    }
}


#Preview {
    ListView()
}
