//
//  ListViewModelTests.swift
//  ToDoListTests
//
//  Created by Diana G on 25.10.2025.
//

import Testing
import XCTest

@testable import ToDoList

final class ListViewModelTests: XCTestCase {
    private var sut: ListViewModel!
    private var storageServiceMocks: StorageServiceMocks!
    private var networkServiceMocks: NetworkServiceMocks!

    private var expectation: XCTestExpectation!

    override func setUp() {
        storageServiceMocks = StorageServiceMocks()
        networkServiceMocks = NetworkServiceMocks()
        sut = ListViewModel(
            storageService: storageServiceMocks,
            networkService: networkServiceMocks
        )
        expectation = expectation(description: "Testing Async")

        super.setUp()
    }

    override func tearDown() {
        super.tearDown()

        sut = nil
        storageServiceMocks = nil
        networkServiceMocks = nil
        expectation = nil
    }

    func test_create() {
        // arrange
        let todo = ToDo(id: 1, todo: "", completed: true, descriptions: "", date: "", userId: 1)

        // act
        sut.create(todo: todo)

        // assert
        let bg = DispatchQueue.global(qos: .background)
        bg.asyncAfter(deadline: .now() + 5) { [weak self ] in
            XCTAssertEqual(self?.storageServiceMocks.todos, [todo])
            self?.expectation.fulfill()
        }

        waitForExpectations(timeout: 60) { (error) in
            if let error = error {
                XCTFail("WaitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func test_update() {
        // arrange
        let todo = ToDo(id: 1, todo: "", completed: true, descriptions: "", date: "", userId: 1)

        // act
        storageServiceMocks.todos = [ToDo(id: 1, todo: "1111111", completed: true, descriptions: "", date: "", userId: 1)]
        sut.update(todo: todo)

        // assert
        let bg = DispatchQueue.global(qos: .background)
        bg.asyncAfter(deadline: .now() + 5) { [weak self ] in
            XCTAssertEqual(self?.storageServiceMocks.todos, [todo])
            self?.expectation.fulfill()
        }

        waitForExpectations(timeout: 60) { (error) in
            if let error = error {
                XCTFail("WaitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func test_delete() {
        // arrange

        // act
        storageServiceMocks.todos = [ToDo(id: 1, todo: "1111111", completed: true, descriptions: "", date: "", userId: 1)]
        sut.deleteToDo(id: 1)

        // assert
        let bg = DispatchQueue.global(qos: .background)
        bg.asyncAfter(deadline: .now() + 5) { [weak self ] in
            XCTAssertEqual(self?.storageServiceMocks.todos, [])
            self?.expectation.fulfill()
        }

        waitForExpectations(timeout: 60) { (error) in
            if let error = error {
                XCTFail("WaitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
