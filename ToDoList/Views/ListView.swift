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
                    viewModel.create(todo: toDo)
                }
            }
        )
        .navigationDestination(
            item: $viewModel.editViewPresented,
            destination: { todoForEdit in
                ToDoView(todo: todoForEdit) { editedTodo in
                    viewModel.update(todo: editedTodo)
                }
            }
        )
    }
    
    var contentView: some View {
        VStack(alignment: .center) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    searchView
                    listView
                        .padding(.bottom, 8)
                }
            }
            bottomView
        }
    }
    
    var searchView: some View {
        TextField("Search", text: $viewModel.searchText)
//            .textInputAutocapitalization(.none)
//                .disableAutocorrection(true)
//                .keyboardType(.asciiCapable)
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
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
    }
    
    var listView: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.filteredToDoList) { toDo in
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.toggleCompletion(for: toDo)
                            }
                        } label: {
                            Image(systemName: toDo.completed ? "checkmark.circle" : "circle")
                                .font(.system(size: 27))
                                .foregroundStyle(toDo.completed ? .yellow : .gray)
                        }
                        // .buttonStyle(.plain)
                        
                        VStack(alignment: .leading, spacing: 7) {
                            Text(toDo.todo)
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(toDo.completed ? .gray : .primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .strikethrough(toDo.completed, color: toDo.completed ? .secondary : .primary)
                            Text(toDo.descriptions)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(toDo.completed ? .gray : .primary)
                            
                            Text(toDo.date)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(toDo.completed ? .gray : .primary)
                        }
                    }
                    Divider()
                        .background(.primary)
                        .padding(.vertical, 15)
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
 
                    ShareLink(
                        item: toDo.todo,
                        message: Text("Поделиться"),
                        preview: SharePreview("Задача", image: Image(systemName: "checkmark.circle"))
                    ) {
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
        ZStack(alignment: .top) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)

            HStack {
                Spacer()
                    .frame(width: 68)

                Spacer()

                Text("\(viewModel.toDoList.count) Задач")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(UIColor.label))

                Spacer()

                Button(action: {
                    viewModel.createViewPresented = true
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 22))
                        .foregroundStyle(.yellow)
                        .frame(width: 68, height: 44)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 6)
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ListView()
}
