//
//  PostsListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct PostsListView: View {
    
    @EnvironmentObject var postsStore: PostsStore
    
    var body: some View {
        LCEView(viewModel: postsStore) {
            List(postsStore.model) { post in
                NavigationLink(destination: PostDetailsView().environmentObject(PostStore(post: post))) {
                    PostRowView(post: post)
                }
            }
        }
        .navigationBarTitle(Text("Posts"))
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let postsStore = PostsStore()
        postsStore.model = [testPost]
        postsStore.state = .content
        return PostsListView().environmentObject(postsStore)
    }
}
