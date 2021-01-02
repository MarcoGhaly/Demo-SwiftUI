//
//  BaseLCEListView.swift
//  Demo
//
//  Created by Marco Ghaly on 02/01/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct BaseLCEListView<Element, DataSource, ViewModel, CellContent, Destination>: View where Element: Identifiable, Element.ID == Int, DataSource: DemoDataSource, ViewModel: BaseLCEListViewModel<Element, DataSource>, CellContent: View, Destination: View {
    @ObservedObject var viewModel: ViewModel
    var showNavigationBarItems = true
    @Binding var presentAddView: Bool
    let cellContent: (Element) -> CellContent
    let destination: (Element) -> Destination
    
    @State private var isEditMode = false
    @State private var selectedIDs = Set<Int>()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            DefaultLCEListView(viewModel: viewModel, isEditMode: isEditMode, selectedIDs: $selectedIDs) { element in
                cellView(forElement: element)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.none)
            
            if isEditMode {
                editView
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .if(showNavigationBarItems) {
            $0.navigationBarItems(trailing: navigationBarItems)
        }
    }
    
    private func cellView(forElement element: Element) -> some View {
        NavigationLink(destination: NavigationLazyView(destination(element))) {
            VStack {
                HStack {
                    cellContent(element)
                    
                    if isEditMode {
                        Image(systemName: selectedIDs.contains(element.id) ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                
                Divider()
            }
        }
        .disabled(isEditMode)
    }
    
    private var editView: some View {
        HStack {
            Button {
                viewModel.deleteObjects(withIDs: selectedIDs)
                isEditMode = false
            } label: {
                VStack {
                    Image(systemName: "trash")
                    Text("Delete")
                }
            }
        }
        .disabled(selectedIDs.isEmpty)
        .frame(maxWidth: .infinity)
        .padding()
        .cardify()
        .transition(.move(edge: .bottom))
    }
    
    private var navigationBarItems: some View {
        HStack {
            if viewModel.model?.isEmpty == false {
                Button(action: {
                    selectedIDs = []
                    withAnimation {
                        isEditMode.toggle()
                    }
                }, label: {
                    Image(systemName: isEditMode ? "multiply.circle.fill" : "pencil.circle.fill")
                })
            }
            
            if !isEditMode {
                Button(action: {
                    withAnimation {
                        presentAddView = true
                    }
                }, label: {
                    Image(systemName: "note.text.badge.plus")
                })
            }
        }
    }
}

struct BaseLCEListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BaseLCEListViewModel<TempModel, TempDataSource>(dataSource: TempDataSource())
        BaseLCEListView(viewModel: viewModel, presentAddView: .constant(false)) { object in
            Text("")
        } destination: { object in
            Text("")
        }
    }
}

import Combine
import RealmSwift

@objcMembers
class TempModel: Object, Identified, Encodable, Identifiable {
    var id: Int = 0
}

class TempDataSource: DemoDataSource {
    var methodName: String = ""
    var idKey: String = ""
    var subscriptions: [AnyCancellable] = []
}
