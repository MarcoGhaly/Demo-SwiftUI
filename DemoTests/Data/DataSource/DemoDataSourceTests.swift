import XCTest
import Combine
@testable import Demo

final class DemoDataSourceTests: XCTestCase {
    // MARK: - Remote
    
    func testGetRemoteData_whenCalled_callsNetworkAgentWithCorrectValues() {
        let methodName = "base"
        let instanceQueryParameters = ["one": "1", "two": "2"]
        let localQueryParameters = ["two": "2", "three": "3"]
        let page = Int.random(in: 1...9)
        let limit = Int.random(in: 1...9)
        
        let networkAgent = NetworkAgentMock()
        let sut = DemoDataSourceExample(methodName: methodName, networkAgent: networkAgent, queryParameters: instanceQueryParameters)
        let _: AnyPublisher<[DataModelMock], DataError> = sut.getRemoteData(queryParameters: localQueryParameters, page: page, limit: limit)
        
        let requests = networkAgent.performRequestCalls
        XCTAssertEqual(requests.count, 1)
        
        let request = requests.first
        
        let expectedQueryParameters = [
            "one": "1",
            "two": "2",
            "three": "3",
            "_page": "\(page)",
            "_limit": "\(limit)"
        ]
        
        XCTAssertEqual(request?.url, methodName)
        XCTAssertEqual(request?.queryParameters, expectedQueryParameters)
    }
    
    // MARK: - Local
    
    func testGetLocalData_whenCalled_callsNetworkAgentWithCorrectValues() {
        let queryParameters = ["one": "1", "two": "2", "three": "3"]
        let page = Int.random(in: 1...9)
        let limit = Int.random(in: 1...9)
        
        let databaseManager = DatabaseManagerMock()
        let sut = DemoDataSourceExample(databaseManager: databaseManager)
        let _: AnyPublisher<[DataModelMock], DataError> = sut.getLocalData(queryParameters: queryParameters, page: page, limit: limit)
        
        let predicates = databaseManager.loadObjectsCalls
        XCTAssertEqual(predicates.count, 1)
        
        let predicateFormat = predicates.first??.predicateFormat
        XCTAssert(predicateFormat?.contains("one == 1") == true)
        XCTAssert(predicateFormat?.contains("two == 2") == true)
        XCTAssert(predicateFormat?.contains("three == 3") == true)
    }
}

private struct DemoDataSourceExample: DemoDataSource {
    var methodName: String = ""
    var networkAgent: NetworkAgentProtocol = NetworkAgentMock()
    var databaseManager: DatabaseManagerProtocol = DatabaseManagerMock()
    var queryParameters: [String : String]?
}
