//
//  ErrorView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/7/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    
    var title: String?
    var message: String?
    var image: (image: Image, size: CGSize)?
    var retry: (label: String, action: () -> Void)?
    var padding: CGFloat = 25
    var spacing: CGFloat = 25
    
    var body: some View {
        VStack(spacing: spacing) {
            if title != nil {
                Text(title!)
                    .font(.title)
            }
            
            if message != nil {
                Text(message!)
                    .font(.body)
            }
            
            if image != nil {
                image!.image
                    .resizable()
                    .frame(width: image!.size.width, height: image!.size.height)
            }
            
            if retry != nil {
                Button(retry!.label, action: retry!.action)
            }
        }
        .padding(padding)
    }
    
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(title: "Error Title",
                  message: "Error Message",
                  image: (image: Image(systemName: "xmark.octagon"), size: CGSize(width: 50, height: 50)),
                  retry: (label: "Retry", action: {}))
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
