import Foundation
import Combine
import RealmSwift

class BaseLCEListViewModel<Element, UseCases>: LCEListViewModel<Element>
where Element: Object & Identified & Codable, UseCases: DemoUseCases {
    let useCases: UseCases
    
    let actionPublisher = PassthroughSubject<Action, Never>()
    
    init(useCases: UseCases, models: [Element]? = nil, limit: Int? = nil) {
        self.useCases = useCases
        super.init(models: models, limit: limit)
    }
}

// MARK: - Action
extension BaseLCEListViewModel {
    enum Action {
        case add
        case delete(IDs: Set<Int>)
    }
}
