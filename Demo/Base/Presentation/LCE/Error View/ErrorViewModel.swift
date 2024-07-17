import Foundation

enum ImageType {
    case normal
    case system
}

enum ImageMode {
    case original
    case icon
}

struct ErrorViewModel {
    var image: (type: ImageType, name: String, mode: ImageMode?)?
    var title: String?
    var message: String?
    var retry: (label: String, action: () -> Void)?
}
