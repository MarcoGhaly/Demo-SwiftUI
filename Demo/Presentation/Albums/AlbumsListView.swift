import SwiftUI

struct AlbumsListView<ViewModel>: View where ViewModel: AlbumsViewModel<AlbumsUseCases> {
    @ObservedObject var viewModel: ViewModel
    
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
