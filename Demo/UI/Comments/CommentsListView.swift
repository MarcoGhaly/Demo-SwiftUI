//
//  CommentsListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct CommentsListView<DataSource: CommentsDataSource>: View {
    @ObservedObject var viewModel: CommentsViewModel<DataSource>
    
    var body: some View {
        DefaultLCEListView(viewModel: viewModel) { comment in
            VStack {
                CommentRowView(comment: comment)
                Divider()
            }
        }
        .navigationBarTitle(Text("Comments"))
    }
}

struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CommentsViewModel(dataSource: CommentsRepository(), postID: testPost.id)
        viewModel.model = [testComment]
        viewModel.viewState = .content
        return CommentsListView(viewModel: viewModel)
    }
}
