//
//  AlbumsListView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/17/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct AlbumsListView<DataSource: AlbumsDataSource>: View {
    @ObservedObject var viewModel: AlbumsViewModel<DataSource>
    
    var body: some View {
        BaseLCEListView(viewModel: viewModel, showEditButtons: viewModel.userID != nil) { album in
            AlbumRowView(album: album)
        } destination: { album in
            PhotosListView(viewModel: PhotosViewModel(dataSource: PhotosRepository(), albumID: album.id))
        }
        .navigationBarTitle("Albums")
    }
}

struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlbumsViewModel(dataSource: AlbumsRepository())
        viewModel.model = [testAlbum]
        viewModel.viewState = .content
        return AlbumsListView(viewModel: viewModel)
    }
}
