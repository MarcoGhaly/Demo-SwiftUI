import SwiftUI

struct AlbumRowView: View {
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

struct AlbumRowView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumRowView(album: TestData.testAlbum)
            .previewLayout(.sizeThatFits)
    }
}
