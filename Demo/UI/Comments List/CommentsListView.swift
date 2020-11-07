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
    
    var body: some View {
        LCEView(viewModel: commentsStore) {
            List(commentsStore.model) { comment in
                CommentRowView(comment: comment)
            }
        }
        .navigationBarTitle(Text("Comments"))
    }
}

struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        let commentsStore = CommentsStore(postID: testPost.id)
        commentsStore.model = [testComment]
        commentsStore.state = .content
        return CommentsListView().environmentObject(commentsStore)
    }
}
