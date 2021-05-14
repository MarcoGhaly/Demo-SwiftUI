import Foundation
import RealmSwift

@objcMembers
class ToDo: Object, Codable, Identifiable, Identified {
    dynamic var userId = 0
    dynamic var id = 0
    dynamic var title: String?
    dynamic var completed: Bool?
    
    override init() {}
    
    init(userId: Int = 0, id: Int = 0, title: String? = nil, completed: Bool? = nil) {
        self.userId = userId
        self.id = id
        self.title = title
        self.completed = completed
    }
    
    override class func primaryKey() -> String? { "id" }
}
