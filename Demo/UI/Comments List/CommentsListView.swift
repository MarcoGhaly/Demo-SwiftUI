//
//  CommentsListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct CommentsListView: View {
    
    @EnvironmentObject var commentsStore: CommentsStore
    
    var post: Post?
    
    var body: some View {
        ZStack {
            if commentsStore.loading {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                    Spacer()
                }
            } else {
                List(commentsStore.comments) { comment in
                    CommentRowView(comment: comment)
                }
            }
        }.navigationBarTitle(Text("Comments")).onAppear {
            if self.commentsStore.comments.isEmpty {
                self.commentsStore.fetchComments(postID: self.post?.id)
            }
        }
    }
}

struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        let commentsStore = CommentsStore()
        commentsStore.loading = false
        commentsStore.comments = [testComment]
        return CommentsListView(post: testPost).environmentObject(commentsStore)
    }
}
