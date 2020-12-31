//
//  UsersViewModelTests.swift
//  DemoTests
//
//  Created by Marco Ghaly on 29/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import XCTest
import Combine
@testable import Demo

class UsersViewModelTests: LCEListViewModelTests {
    func testUsersViewModel() {
        let viewModel = UsersViewModel(dataSource: UsersTestRepository())
        testGetUsers(viewModel: viewModel)
        testAddUser(viewModel: viewModel)
        testDeleteFirstUser(viewModel: viewModel)
        testDeleteAllUsers(viewModel: viewModel)
    }
    
    private func testGetUsers(viewModel: UsersViewModel<UsersTestRepository>) {
        testPagination(viewModel: viewModel, pages: 3, limit: 5, totalCount: 10)
    }
    
    private func testAddUser(viewModel: UsersViewModel<UsersTestRepository>) {
        let user = User(id: 1, name: "Test Name", username: "Test Username")
        viewModel.add(user: user)
        
        validateLoading(viewModel: viewModel)
        
        let expectation = self.expectation(description: "Add User Callback")
        expectation.expectedFulfillmentCount = 2
        let cancellable = viewModel.objectWillChange.sink {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        cancellable.cancel()
        
        validateContent(viewModel: viewModel)
        
        XCTAssertEqual(viewModel.model?.count, 11)
        XCTAssertEqual(viewModel.model?.first, user)
    }
    
    private func testDeleteFirstUser(viewModel: UsersViewModel<UsersTestRepository>) {
        let user = viewModel.model![0]
        let nextUser = viewModel.model![1]
        testDelete(users: [user], viewModel: viewModel)
        XCTAssertEqual(viewModel.model?.count, 10)
        XCTAssertEqual(viewModel.model?.first, nextUser)
    }
    
    private func testDeleteAllUsers(viewModel: UsersViewModel<UsersTestRepository>) {
        testDelete(users: viewModel.model!, viewModel: viewModel)
        XCTAssertEqual(viewModel.model?.count, 0)
        validateError(viewModel: viewModel)
    }
    
    private func testDelete(users: [User], viewModel: UsersViewModel<UsersTestRepository>) {
        let newCount = viewModel.model!.count - users.count
        
        let userIDs = users.map { $0.id }
        viewModel.deleteUsers(wihtIDs: Set(userIDs))
        
        validateLoading(viewModel: viewModel)
        
        let expectation = self.expectation(description: "Delete User Callback")
        expectation.expectedFulfillmentCount = 2
        let cancellable = viewModel.objectWillChange.sink {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        cancellable.cancel()
        
        validateContent(viewModel: viewModel)
        XCTAssertEqual(viewModel.model?.count, newCount)
    }
}

private class UsersTestRepository: TestDataSource, UsersDataSource {
    func getUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAppError> {
        let publisher = PassthroughSubject<[User], DefaultAppError>()
        DispatchQueue.main.async {
            let users = [User](repeating: User(), count: page! < 3 ? limit! : 0)
            publisher.send(users)
            publisher.send(completion: .finished)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    func add(user: User) -> AnyPublisher<User, DefaultAppError> {
        add(object: user)
    }
    
    func remove(users: [User]) -> AnyPublisher<Void, DefaultAppError> {
        remove(objects: users)
    }
}
