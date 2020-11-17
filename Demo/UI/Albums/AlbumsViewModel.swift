//
//  AlbumsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 11/17/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

class AlbumsViewModel: LCEViewModel<[Album]> {
    
    init() {
        let albumsDataSource = AlbumsDataSource()
        super.init(model: [], publisher: albumsDataSource.getAllAlbums())
    }
    
}
