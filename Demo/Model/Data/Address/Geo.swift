import Foundation
import RealmSwift

@objcMembers
class Geo: Object, Codable {
	dynamic var lat : String?
	dynamic var lng : String?
    
    override init() {}
    
    init(lat: String? = nil, lng: String? = nil) {
        self.lat = lat
        self.lng = lng
    }
}
