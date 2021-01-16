//
//  PhotosListView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/18/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI
import ImageViewerRemote

struct PhotosListView<DataSource: PhotosDataSource>: View {
    @ObservedObject var viewModel: PhotosViewModel<DataSource>
    
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
                .onTapGesture {
                    imageURL = photo.url
                }
        } destination: { _ in }
        .overlay(imageViewer)
        .navigationBarTitle("Photos")
    }
    
    private var imageViewer: some View {
        imageURL.map {
            ImageViewerRemote(imageURL: .constant($0), viewerShown: showImageViewer)
        }
    }
}

struct PhotosListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PhotosViewModel(dataSource: PhotosRepository())
        viewModel.model = [testPhoto]
        viewModel.viewState = .content
        return PhotosListView(viewModel: viewModel)
    }
}
