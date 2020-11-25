//
//  AlbumsListView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/17/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct AlbumsListView: View {
    
    @ObservedObject var viewModel: AlbumsViewModel
    
    var body: some View {
        LCEView(viewModel: viewModel) { model in
            List(model) { album in
                NavigationLink(
                    destination: NavigationLazyView(PhotosListView(viewModel: PhotosViewModel(albumID: album.id)))) {
                    AlbumRowView(album: album)
                }
            }
        }
        .navigationBarTitle("Albums")
    }
}

struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlbumsViewModel()
        viewModel.model = [testAlbum]
        viewModel.state = .content
        return AlbumsListView(viewModel: viewModel)
    }
}
