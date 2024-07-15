//
//  CommentsListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct CommentsListView<UseCases: CommentsUseCases>: View {
    @ObservedObject var viewModel: CommentsViewModel<UseCases>
    
    var body: some View {
        BaseLCEListView(viewModel: viewModel, showEditButtons: viewModel.postID != nil) { comment in
            CommentRowView(comment: comment)
        }
        .if(viewModel.postID == nil) {
            $0.navigationBarTitle("Comments")
        }
    }
}

struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CommentsViewModel(useCases: CommentsUseCases(), postID: testPost.id)
        viewModel.model = [testComment]
        viewModel.viewState = .content
        return CommentsListView(viewModel: viewModel)
    }
}
