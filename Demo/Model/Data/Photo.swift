import Foundation
import RealmSwift

@objcMembers
class Photo: Object, Codable, Identifiable, Identified {
    dynamic var albumId = 0
    dynamic var id = 0
    dynamic var title : String?
    dynamic var url : String?
    dynamic var thumbnailUrl : String?
    
    override init() {}
    
    init(albumId: Int = 0, id: Int = 0, title: String? = nil, url: String? = nil, thumbnailUrl: String? = nil) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
    
    override class func primaryKey() -> String? { "id" }
}
