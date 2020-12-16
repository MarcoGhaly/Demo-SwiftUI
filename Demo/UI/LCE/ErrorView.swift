//
//  ErrorView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/7/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

enum ImageType {
    case normal
    case system
}

enum ImageMode {
    case original
    case icon
}

struct ErrorView: View {
    private let padding: CGFloat = 25
    private let spacing: CGFloat = 25
    private let iconDimension: CGFloat = 50
    
    var title: String?
    var message: String?
    var image: (type: ImageType, name: String, mode: ImageMode?)?
    var retry: (label: String, action: () -> Void)?
    
    var body: some View {
        VStack(spacing: spacing) {
            image.map { image in
                (image.type == .normal ? Image(image.name) : Image(systemName: image.name))
                    .if(image.mode == .icon) {
                        $0.resizable()
                            .frame(width: iconDimension, height: iconDimension)
                    }
            }
            
            title.map { title in
                Text(title)
                    .font(.title)
            }
            
            message.map { message in
                Text(message)
                    .font(.body)
            }
            
            retry.map { retry in
                Button(retry.label, action: retry.action)
            }
        }
        .padding(padding)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(title: "Error Title",
                  message: "Error Message",
                  image: (type: .system, name: "multiply.circle", mode: .icon),
                  retry: (label: "Retry", action: {}))
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
