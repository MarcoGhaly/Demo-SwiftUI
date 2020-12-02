//
//  AlbumRowView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/17/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct AlbumRowView: View {
    var album: Album
    
    var body: some View {
        Group {
            album.title.map { title in
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                    .padding()
            }
        }
    }
}

struct AlbumRowView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumRowView(album: testAlbum)
            .previewLayout(.sizeThatFits)
    }
}
