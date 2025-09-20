import SwiftUI

struct AlbumItemView: View {
    var album: Album
    
    var body: some View {
        Group {
            album.title.map { title in
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                    .padding()
            }
        }
    }
}

#Preview {
    AlbumItemView(album: TestData.testAlbum)
        .previewLayout(.sizeThatFits)
}
