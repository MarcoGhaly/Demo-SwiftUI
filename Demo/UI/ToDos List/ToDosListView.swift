//
//  ToDosListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct ToDosListView: View {
    
    @EnvironmentObject var toDosStore: ToDosStore
    
    var body: some View {
        ZStack {
            if toDosStore.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } else {
                List(toDosStore.toDos) { toDo in
                    ToDoRowView(toDo: toDo)
                }
            }
        }.navigationBarTitle(Text("ToDos"))
            .onAppear {
                if self.toDosStore.toDos.isEmpty {
                    self.toDosStore.fetchToDos()
                }
        }
    }
}

struct ToDosListView_Previews: PreviewProvider {
    static var previews: some View {
        let toDosStore = ToDosStore()
        toDosStore.toDos = [testToDo]
        return ToDosListView().environmentObject(toDosStore)
    }
}
