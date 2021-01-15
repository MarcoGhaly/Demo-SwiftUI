//
//  PhotosListView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/18/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI
import QGrid

struct PhotosListView<DataSource: PhotosDataSource>: View {
    @ObservedObject var viewModel: PhotosViewModel<DataSource>
    
    var body: some View {
        BaseLCEListView(viewModel: viewModel, columns: 3, showEditButtons: viewModel.albumID != nil) { photo in
            PhotoCellView(photo: photo)
        } destination: { photo in
            PhotoCellView(photo: photo)
        }
        .navigationBarTitle("Photos")
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
