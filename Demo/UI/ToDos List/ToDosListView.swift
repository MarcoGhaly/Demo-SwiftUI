//
//  ToDosListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct ToDosListView: View {
    
    @ObservedObject var viewModel: ToDosViewModel
    
    var body: some View {
        LCEView(viewModel: viewModel) {
            List(viewModel.model) { toDo in
                ToDoRowView(toDo: toDo)
            }
        }
        .navigationBarTitle(Text("ToDos"))
    }
}

struct ToDosListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ToDosViewModel()
        viewModel.model = [testToDo]
        viewModel.state = .content
        return ToDosListView(viewModel: viewModel)
    }
}
