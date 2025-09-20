import SwiftUI
import SDWebImageSwiftUI

struct PhotoItemView: View {
    var photo: Photo
    
    var body: some View {
        photo.thumbnailUrl.map { urlString in
            WebImage(url: URL(string: urlString))
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    PhotoItemView(photo: TestData.testPhoto)
        .previewLayout(.sizeThatFits)
}
