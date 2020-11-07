//
//  ToDosListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct ToDosListView: View {
    
    @ObservedObject var toDosStore: ToDosStore
    
    var body: some View {
        LCEView(viewModel: toDosStore) {
            List(toDosStore.model) { toDo in
                ToDoRowView(toDo: toDo)
            }
        }
        .navigationBarTitle(Text("ToDos"))
    }
}

struct ToDosListView_Previews: PreviewProvider {
    static var previews: some View {
        let toDosStore = ToDosStore()
        toDosStore.model = [testToDo]
        toDosStore.state = .content
        return ToDosListView(toDosStore: toDosStore)
    }
}
