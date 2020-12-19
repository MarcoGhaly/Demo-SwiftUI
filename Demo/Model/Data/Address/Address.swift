import Foundation
import RealmSwift

@objcMembers
class Address: Object, Codable {
    dynamic var street : String?
    dynamic var suite : String?
    dynamic var city : String?
    dynamic var zipcode : String?
    dynamic var geo : Geo?
    
    override var description: String {
        var address = street ?? ""
        suite.map {
            address += ", \($0)"
        }
        city.map {
            address += ", \($0)"
        }
        return address
    }
    
    override init() {}
    
    init(street: String?, suite: String?, city: String?, zipcode: String?, geo: Geo?) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = geo
    }
}
