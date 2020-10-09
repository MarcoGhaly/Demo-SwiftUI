//
//  ToDoRowView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct ToDoRowView: View {
    
    var toDo: ToDo
    
    var body: some View {
        HStack {
            toDo.title.map {
                Text($0).font(.headline)
            }
            
            Spacer()
            
            if toDo.completed ?? false {
                Image(systemName: "checkmark.circle.fill").imageScale(.large).foregroundColor(.green)
            }
        }.padding()
    }
}

struct ToDoRowView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoRowView(toDo: testToDo).previewLayout(.sizeThatFits)
    }
}
