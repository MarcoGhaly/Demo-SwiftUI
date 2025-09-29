import XCTest
import Combine
@testable import Demo

class LCEListViewModelTests: LCEViewModelTests {
    func testEmptyData() {
        let viewModel = LCEListViewModelTest(totalCount: .zero)
        
        validateLoading(viewModel: viewModel)
        
        let expectation = self.expectation(description: "Data Callback")
        let cancellable = viewModel.$model.dropFirst().sink { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        cancellable.cancel()
        
        validateError(viewModel: viewModel)
    }
    
    func testSinglePage() {
        let totalCount = 3
        let viewModel = LCEListViewModelTest(totalCount: totalCount)
        
        testViewStates(viewModel: viewModel)
        XCTAssertEqual(viewModel.model?.count, totalCount)
        
        viewModel.scrolledToEnd()
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testPagination() {
        testPagination(pages: 3, limit: 3, lastPageLimit: 1)
        testPagination(pages: 3, limit: 3, lastPageLimit: 0)
    }
    
    private func testPagination(pages: Int, limit: Int, lastPageLimit: Int) {
        let totalCount = (pages - 1) * limit + lastPageLimit
        let viewModel = LCEListViewModelTest(totalCount: totalCount, pages: pages, limit: limit)
        testPagination(viewModel: viewModel, pages: pages, limit: limit, totalCount: totalCount)
    }
    
    func testPagination<T>(viewModel: LCEListViewModel<T, AppError>, pages: Int, limit: Int, totalCount: Int) {
        testViewStates(viewModel: viewModel)
        XCTAssertEqual(viewModel.model?.count, limit)
        
        for page in 2...pages {
            viewModel.scrolledToEnd()
            XCTAssertTrue(viewModel.isLoading)
            
            let expectation = self.expectation(description: "Data Callback")
            let cancellable = viewModel.$model.dropFirst().sink { _ in
                expectation.fulfill()
            }
            waitForExpectations(timeout: 1)
            cancellable.cancel()
            
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(viewModel.model?.count, page == pages ? totalCount : limit * 2)
        }
        
        viewModel.scrolledToEnd()
        XCTAssertFalse(viewModel.isLoading)
    }
}

private class LCEListViewModelTest: LCEListViewModel<TestModel, AppError> {
    private let totalCount: Int
    private let pages: Int?
    private let limit: Int?
    
    private var lastPageLimit: Int? {
        guard let pages = self.pages, let limit = limit else { return nil }
        return totalCount - (pages - 1) * limit
    }
    
    init(model: [TestModel]? = nil, totalCount: Int, pages: Int? = nil, limit: Int? = nil) {
        self.totalCount = totalCount
        self.pages = pages
        self.limit = limit
        super.init(models: model, limit: limit)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[TestModel], AppError> {
        let publisher = PassthroughSubject<[TestModel], AppError>()
        DispatchQueue.main.async {
            let count: Int
            if let pages = self.pages, let limit = limit, let lastPageLimit = self.lastPageLimit {
                count = page < pages ? limit : lastPageLimit
            } else {
                count = self.totalCount
            }
            
            let models = [TestModel](repeating: TestModel(), count: count)
            publisher.send(models)
            publisher.send(completion: .finished)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    override func loadingViewModel() -> LoadingViewModel { testLoadingViewModel }
    
    override func errorViewModel(fromError error: Error) -> ErrorViewModel { testErrorViewModel }
    
    override func emptyModelErrorViewModel() -> ErrorViewModel { testErrorViewModel }
}
