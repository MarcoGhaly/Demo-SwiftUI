import Foundation

struct Post: Codable, Identifiable {
    var userId : Int?
    var id : Int?
    var title : String?
    var body : String?
    var comments: [Comment]?
}
