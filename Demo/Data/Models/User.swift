import Foundation
import RealmSwift

@objcMembers
class User: Object, Codable, Identifiable, Identified {
    dynamic var id = 0
    dynamic var name: String?
    dynamic var username: String?
    dynamic var email: String?
    dynamic var address: Address?
    dynamic var phone: String?
    dynamic var website: String?
    dynamic var company: Company?
    
    override init() {}
    
    init(
        id: Int = 0,
        name: String? = nil,
        username: String? = nil,
        email: String? = nil,
        address: Address? = nil,
        phone: String? = nil,
        website: String? = nil,
        company: Company? = nil
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
    
    override class func primaryKey() -> String? { "id" }
}
