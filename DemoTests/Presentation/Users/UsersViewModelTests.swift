import XCTest
import Combine
@testable import Demo

class UsersViewModelTests: LCEListViewModelTests {
    func testModelChanges() {
        let user = User(id: 1, name: "Test Name", username: "Test Username")
        let viewModel = UsersViewModel(useCases: UsersUseCasesMock(), users: [user])
        validateContent(viewModel: viewModel)
        viewModel.model?.removeFirst()
        validateError(viewModel: viewModel)
    }
    
    func testUsersViewModel() {
        let viewModel = UsersViewModel(useCases: UsersUseCasesMock())
        testGetUsers(viewModel: viewModel)
        testAddUser(viewModel: viewModel)
        testDeleteFirstUser(viewModel: viewModel)
        testDeleteAllUsers(viewModel: viewModel)
    }
    
    private func testGetUsers(viewModel: UsersViewModel<UsersUseCasesMock>) {
        testPagination(viewModel: viewModel, pages: 3, limit: 5, totalCount: 10)
    }
    
    private func testAddUser(viewModel: UsersViewModel<UsersUseCasesMock>) {
        let user = User(id: 1, name: "Test Name", username: "Test Username")
        viewModel.add(user: user)
        
        validateLoading(viewModel: viewModel)
        
        let expectation = self.expectation(description: "Add User Callback")
        let cancellable = viewModel.$model.dropFirst().sink { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        cancellable.cancel()
        
        validateContent(viewModel: viewModel)
        
        XCTAssertEqual(viewModel.model?.count, 11)
        XCTAssertEqual(viewModel.model?.first, user)
    }
    
    private func testDeleteFirstUser(viewModel: UsersViewModel<UsersUseCasesMock>) {
        let user = viewModel.model![0]
        let nextUser = viewModel.model![1]
        testDelete(users: [user], viewModel: viewModel)
        XCTAssertEqual(viewModel.model?.first, nextUser)
    }
    
    private func testDeleteAllUsers(viewModel: UsersViewModel<UsersUseCasesMock>) {
        testDelete(users: viewModel.model!, viewModel: viewModel)
    }
    
    private func testDelete(users: [User], viewModel: UsersViewModel<UsersUseCasesMock>) {
        let newCount = viewModel.model!.count - users.count
        
        let userIDs = users.map { $0.id }
        viewModel.deleteUsers(withIDs: Set(userIDs))
        
        validateLoading(viewModel: viewModel)
        
        let expectation = self.expectation(description: "Delete User Callback")
        let cancellable = viewModel.$model.dropFirst().sink { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        cancellable.cancel()
        
        XCTAssertEqual(viewModel.model?.count, newCount)
        
        if newCount == 0 {
            validateError(viewModel: viewModel)
        } else {
            validateContent(viewModel: viewModel)
        }
    }
}
