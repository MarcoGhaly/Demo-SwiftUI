//
//  CommentRowView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct CommentRowView: View {
    
    var comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("Name:").font(.subheadline)
                comment.name.map {
                    Text($0).font(.subheadline)
                }
            }
            
            HStack(alignment: .top) {
                Text("Email:").font(.subheadline)
                comment.email.map {
                    Text($0).font(.subheadline)
                }
            }
            
            comment.body.map {
                Text($0).font(.subheadline)
            }
        }
    }
}

struct CommentRowView_Previews: PreviewProvider {
    static var previews: some View {
        return CommentRowView(comment: testComment).previewLayout(.sizeThatFits)
    }
}
