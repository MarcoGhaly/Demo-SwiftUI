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
        ZStack {
            if postsStore.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } else {
                List(postsStore.posts) { post in
                    NavigationLink(destination: PostDetailsView().environmentObject(PostStore(post: post))) {
                        PostRowView(post: post)
                    }
                }
            }
        }.navigationBarTitle(Text("Posts")).onAppear {
            if self.postsStore.posts.isEmpty {
                self.postsStore.fetchPosts()
            }
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let postsStore = PostsStore()
        postsStore.posts = [testPost]
        return PostsListView().environmentObject(postsStore)
    }
}
