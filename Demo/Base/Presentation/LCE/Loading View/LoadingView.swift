import Foundation
import SwiftUI

protocol LoadingView: View {
    var loadingViewModel: LoadingViewModel { get set }
}
