//
//  PostDetailsView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct PostDetailsView: View {
    
    @EnvironmentObject var postStore: PostStore
    
    var body: some View {
        VStack(alignment: .leading) {
            postStore.post.title.map {
                Text($0).font(.headline)
            }
            postStore.post.body.map {
                Text($0).font(.body)
            }
            
            Divider()
            
            Text("Comments:").font(.title)
            
            CommentsListView(post: postStore.post).environmentObject(CommentsStore()).frame(maxHeight: .infinity)
        }.padding().navigationBarTitle(Text(postStore.post.title ?? ""))
    }
}

struct PostDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let postStore = PostStore(post: testPost)
        return PostDetailsView().environmentObject(postStore)
    }
}
