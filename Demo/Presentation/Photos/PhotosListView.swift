import SwiftUI
import ImageViewerRemote

struct PhotosListView<ViewModel>: View where ViewModel: PhotosViewModel<PhotosUseCases> {
    @ObservedObject var viewModel: ViewModel
    
    @State private var imageURL: String?
    
    private var showImageViewer: Binding<Bool> {
        Binding {
            if let imageURL = self.imageURL, URL(string: imageURL) != nil {
                return true
            }
            return false
        } set: { _ in
            imageURL = nil
        }
    }
    
    var body: some View {
        BaseLCEListView(viewModel: viewModel, columns: 3, showEditButtons: viewModel.albumID != nil) { photo in
            PhotoCellView(photo: photo)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .onTapGesture {
                    imageURL = photo.url
                }
        }
        .overlay(imageViewer)
        .navigationBarTitle("Photos")
    }
    
    private var imageViewer: some View {
        imageURL.map {
            ImageViewerRemote(imageURL: .constant($0), viewerShown: showImageViewer)
        }
    }
}

#Preview {
    let viewModel = PhotosViewModel(useCases: PhotosUseCases())
    viewModel.model = [TestData.testPhoto]
    viewModel.viewState = .content
    return PhotosListView(viewModel: viewModel)
}
