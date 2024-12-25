import XCTest
@testable import Demo

final class UsersUseCasesTests: XCTestCase {
    func testGetUsers_whenCalledWhenDataSourceReturnsSuccess_returnsLocalAndRemoteUsersFromDataSource() {
        let localUsers = (1...2).map { User(id: $0, name: "Local User \($0)") }
        let remoteUsers = (3...5).map { User(id: $0, name: "Remote User \($0)") }
        
        typealias TestCase = (page: Int, users: [User])
        let testCases: [TestCase] = [
            (page: 1, users: localUsers + remoteUsers),
            (page: 2, users: remoteUsers),
            (page: 3, users: remoteUsers)
        ]

        let dataSource = UsersDataSourceMock()
        dataSource.stubbedLocalUsers = localUsers
        dataSource.stubbedRemoteUsers = remoteUsers
        
        let sut = UsersUseCases(dataSource: dataSource)
        
        var remoteUsersCallCount = 0
        var localUsersCallCount = 0
        
        testCases.forEach { page, users in
            (1...3).forEach { limit in
                let usersPublisher = sut.getUsers(page: page, limit: limit)
                
                remoteUsersCallCount += 1
                if page == 1 {
                    localUsersCallCount += 1
                }
                
                XCTAssertEqual(dataSource.getRemoteUsersCalls.last?.page, page)
                XCTAssertEqual(dataSource.getRemoteUsersCalls.last?.limit, limit)
                
                let expectation = self.expectation(description: "Publisher Finished")
                
                let cancellable = usersPublisher.sink { completion in
                    if case .finished = completion {
                        expectation.fulfill()
                    }
                } receiveValue: {
                    XCTAssertEqual($0, users)
                }
                
                waitForExpectations(timeout: 0.1)
                
                cancellable.cancel()
            }
        }
        
        XCTAssertEqual(dataSource.getRemoteUsersCalls.count, remoteUsersCallCount)
        XCTAssertEqual(dataSource.getLocalUsersCallCount, localUsersCallCount)
    }
    
    func testGetUsers_whenCalledWhenDataSourceReturnsFailure_mapsErrorToGeneralError() {
        let expectedError = NSError(domain: "Error", code: 1)
        let dataSource = UsersDataSourceMock()
        dataSource.stubbedRemoteUsersCompletion = .failure(.remoteError(error: expectedError))
        
        let sut = UsersUseCases(dataSource: dataSource)
        
        let usersPublisher = sut.getUsers(page: 1, limit: 1)
        
        let expectation = self.expectation(description: "Publisher Failed")
        
        let cancellable = usersPublisher.sink { completion in
            if case let .failure(appError) = completion {
                if case let .general(error) = appError {
                    if case let .remoteError(error) = error as? DataError {
                        XCTAssertEqual(error as NSError, expectedError)
                        expectation.fulfill()
                    }
                }
            }
        } receiveValue: { _ in
            XCTFail()
        }
        
        waitForExpectations(timeout: 0.1)
        
        cancellable.cancel()
    }
}
