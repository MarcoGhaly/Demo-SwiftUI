import SwiftUI

struct AlbumsListView<UseCases: AlbumsUseCases>: View {
    @ObservedObject var viewModel: AlbumsViewModel<UseCases>
    
    var body: some View {
        BaseLCEListView(viewModel: viewModel, showEditButtons: viewModel.userID != nil) { album in
            AlbumRowView(album: album)
        } destination: { album in
            PhotosListView(viewModel: PhotosViewModel(albumID: album.id))
        }
        .navigationBarTitle("Albums")
    }
}

struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlbumsViewModel(useCases: AlbumsUseCases())
        viewModel.model = [testAlbum]
        viewModel.viewState = .content
        return AlbumsListView(viewModel: viewModel)
    }
}
