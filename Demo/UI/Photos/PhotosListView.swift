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
    
    @State private var columns = 3
    
    var body: some View {
        DefaultLCEView(viewModel: viewModel) { model in
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                    ForEach(model) { photo in
                        PhotoCellView(photo: photo)
                            .transition(.slide)
                    }
                }
            }
        }
        .navigationBarTitle("Photos")
        .navigationBarItems(trailing: navigationItems)
    }
    
    private var navigationItems: some View {
        HStack {
            ForEach(1...3, id: \.self) { columns in
                Button(action: {
                    withAnimation {
                        self.columns = columns
                    }
                }, label: {
                    Image(systemName: "rectangle.grid.\(columns)x2.fill")
                })
            }
        }
    }
}

struct PhotosListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PhotosViewModel()
        viewModel.model = [testPhoto]
        viewModel.viewState = .content
        return PhotosListView(viewModel: viewModel)
    }
}
