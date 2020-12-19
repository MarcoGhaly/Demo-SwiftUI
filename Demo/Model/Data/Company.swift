import Foundation
import RealmSwift

@objcMembers
class Company: Object, Codable {
	dynamic var name : String?
	dynamic var catchPhrase : String?
	dynamic var bs : String?
    
    override init() {}
    
    init(name: String? = nil, catchPhrase: String? = nil, bs: String? = nil) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}
