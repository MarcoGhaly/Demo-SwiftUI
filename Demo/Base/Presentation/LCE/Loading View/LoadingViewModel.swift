import Foundation

enum LoadingViewStyle: CaseIterable {
    case normal
    case dialog
}

struct LoadingViewModel {
    var style = LoadingViewStyle.normal
    var title: String?
    var message: String?
}
