import XCTest
import Combine
@testable import Demo

final class DemoDataSourceTests: XCTestCase {
    func testGetRemoteData_whenCalled_callsNetworkAgentWithCorrectValues() {
        let methodName = "base"
        let instanceQueryParameters = ["1": "one", "2": "two"]
        let localQueryParameters = ["2": "two", "3": "three"]
        let page = Int.random(in: 1...9)
        let limit = Int.random(in: 1...9)
        
        let networkAgent = NetworkAgentMock()
        let sut = DemoDataSourceExample(methodName: methodName, networkAgent: networkAgent, queryParameters: instanceQueryParameters)
        let _: AnyPublisher<[DataModelMock], DataError> = sut.getRemoteData(queryParameters: localQueryParameters, page: page, limit: limit)
        
        let requests = networkAgent.performRequestCalls
        XCTAssertEqual(requests.count, 1)
        
        let request = requests.first
        
        let expectedQueryParameters = [
            "1": "one",
            "2": "two",
            "3": "three",
            "_page": "\(page)",
            "_limit": "\(limit)"
        ]
        
        XCTAssertEqual(request?.url, methodName)
        XCTAssertEqual(request?.queryParameters, expectedQueryParameters)
    }
}

private struct DemoDataSourceExample: DemoDataSource {
    var methodName: String
    var networkAgent: NetworkAgentProtocol
    var queryParameters: [String : String]?
}
