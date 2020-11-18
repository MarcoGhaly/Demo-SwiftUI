//
//  PhotoCellView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/18/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoCellView: View {
    
    var photo: Photo
    
    var body: some View {
        Group {
            photo.thumbnailUrl.map { urlString in
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    
}

struct PhotoCellView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCellView(photo: testPhoto)
            .previewLayout(.sizeThatFits)
    }
}
