import Foundation
import RealmSwift

@objcMembers
class Post: Object, Codable, Identifiable, Identified {
    dynamic var userId = 0
    dynamic var id = 0
    dynamic var title: String?
    dynamic var body: String?
    
    override init() {}
    
    init(
        userId: Int = 0,
        id: Int = 0,
        title: String? = nil,
        body: String? = nil
    ) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
    
    override class func primaryKey() -> String? { "id" }
}
