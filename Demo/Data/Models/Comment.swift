import Foundation
import RealmSwift

@objcMembers
class Comment: Object, Codable, Identifiable, Identified {
    dynamic var postId = 0
    dynamic var id = 0
    dynamic var name: String?
    dynamic var email: String?
    dynamic var body: String?
    
    override init() {}
    
    init(
        postId: Int = 0,
        id: Int = 0,
        name: String? = nil,
        email: String? = nil,
        body: String? = nil
    ) {
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
    
    override class func primaryKey() -> String? { "id" }
}
