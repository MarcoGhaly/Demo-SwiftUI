import Foundation

struct ToDo: Codable, Identifiable {
    let userId : Int?
    let id : Int?
    let title : String?
    let completed : Bool?
}
