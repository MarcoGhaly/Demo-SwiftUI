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
        let info = [("Name:", comment.name),
                    ("Email:", comment.email)]
        
        VStack(alignment: .leading) {
            InfoView(info: info)
            
            comment.body.map {
                Text($0)
                    .font(.subheadline)
            }
        }
        .padding(.horizontal)
    }
}

struct CommentRowView_Previews: PreviewProvider {
    static var previews: some View {
        return CommentRowView(comment: testComment).previewLayout(.sizeThatFits)
    }
}
