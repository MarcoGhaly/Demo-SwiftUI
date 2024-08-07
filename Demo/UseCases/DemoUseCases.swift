import Foundation
import Combine
import RealmSwift

protocol DemoUseCases: AnyObject {
    var idKey: String { get }
    func getNextID(withInitialValue id: Int) -> Int
}

extension DemoUseCases {
    func getNextID(withInitialValue id: Int) -> Int {
        let objectID: Int = UserDefaultsManager.loadValue(forKey: idKey) ?? id
        UserDefaultsManager.save(value: objectID + 1, forKey: idKey)
        return objectID
    }
}
