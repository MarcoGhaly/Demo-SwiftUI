//
//  CommentsListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct CommentsListView: View {
    
    @ObservedObject var viewModel: CommentsViewModel
    
    var body: some View {
        LCEView(viewModel: viewModel) {
            List(viewModel.model) { comment in
                CommentRowView(comment: comment)
            }
        }
        .navigationBarTitle(Text("Comments"))
    }
}

struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CommentsViewModel(postID: testPost.id)
        viewModel.model = [testComment]
        viewModel.state = .content
        return CommentsListView(viewModel: viewModel)
    }
}
