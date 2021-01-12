import Foundation
import RealmSwift

@objcMembers
class Album: Object, Codable, Identifiable, Identified {
    dynamic var id = 0
    dynamic var userId = 0
    dynamic var title : String?
    
    override init() {}
    
    init(id: Int = 0, userId: Int = 0, title: String? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
    }
    
    override class func primaryKey() -> String? { "id" }
}
