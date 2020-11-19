//
//  PhotosListView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/18/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI
import QGrid

struct PhotosListView: View {
    
    @ObservedObject var viewModel: PhotosViewModel
    
    var body: some View {
        LCEView(viewModel: viewModel) {
            QGrid(viewModel.model, columns: 3) { photo in
                PhotoCellView(photo: photo)
            }
        }
        .navigationBarTitle("Photos")
    }
    
}

struct PhotosListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PhotosViewModel()
        viewModel.model = [testPhoto]
        viewModel.state = .content
        return PhotosListView(viewModel: viewModel)
    }
}