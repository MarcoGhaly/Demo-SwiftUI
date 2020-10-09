import Foundation

struct Address : Codable, CustomStringConvertible {
    
	let street : String?
	let suite : String?
	let city : String?
	let zipcode : String?
	let geo : Geo?
    
    var description: String {
        var address = street ?? ""
        suite.map {
            address += ", \($0)"
        }
        city.map {
            address += ", \($0)"
        }
        return address
    }

}
