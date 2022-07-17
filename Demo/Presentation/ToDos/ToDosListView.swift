//
//  ToDosListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct ToDosListView<DataSource: ToDosDataSource>: View {
    @ObservedObject var viewModel: ToDosViewModel<DataSource>
    
    var body: some View {
        BaseLCEListView(viewModel: viewModel, showEditButtons: viewModel.userID != nil) { toDo in
            ToDoRowView(toDo: toDo)
        }
        .navigationBarTitle("ToDos")
    }
}

struct ToDosListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ToDosViewModel(dataSource: ToDosRepository())
        viewModel.model = [testToDo]
        viewModel.viewState = .content
        return ToDosListView(viewModel: viewModel)
    }
}
