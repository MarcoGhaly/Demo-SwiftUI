import SwiftUI

struct BaseLCEListView<Element, AppError, UseCases, ViewModel, ItemContent, Destination>: View
where Element: Identifiable, Element.ID == Int, UseCases: DemoUseCases, ViewModel: BaseLCEListViewModel<Element, AppError, UseCases>, ItemContent: View, Destination: View {
    @ObservedObject var viewModel: ViewModel
    @State var columns: Int
    var showGridButtons: Bool
    var showEditButtons: Bool
    @Binding var presentAddView: Bool
    let itemContent: (Element) -> ItemContent
    let destination: (Element) -> Destination
    
    @State private var isEditMode = false
    @State private var selectedIDs = Set<Int>()
    
    init(
        viewModel: ViewModel,
        columns: Int = 1,
        showGridButtons: Bool = true,
        showEditButtons: Bool = true,
        presentAddView: Binding<Bool> = .constant(false),
        @ViewBuilder itemContent: @escaping (Element) -> ItemContent,
        @ViewBuilder destination: @escaping (Element) -> Destination
    ) {
        self.viewModel = viewModel
        self._columns = State(initialValue: columns)
        self.showGridButtons = showGridButtons
        self.showEditButtons = showEditButtons
        self._presentAddView = presentAddView
        self.itemContent = itemContent
        self.destination = destination
    }
    
    init(
        viewModel: ViewModel,
        columns: Int = 1,
        showGridButtons: Bool = true,
        showEditButtons: Bool = true,
        presentAddView: Binding<Bool> = .constant(false),
        @ViewBuilder itemContent: @escaping (Element) -> ItemContent
    ) where Destination == EmptyView {
        self.init(
            viewModel: viewModel,
            columns: columns,
            showGridButtons: showGridButtons,
            showEditButtons: showEditButtons,
            presentAddView: presentAddView,
            itemContent: itemContent,
            destination: { _ in EmptyView() }
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            DefaultLCEListView(
                viewModel: viewModel,
                columns: columns,
                isEditMode: isEditMode,
                selectedIDs: $selectedIDs,
                itemContent: { element in
                    cellView(forElement: element)
                },
                destination: destination
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if isEditMode {
                editView
            }
        }
        .navigationBarItems(leading: gridButtons, trailing: editButtons)
    }
    
    private func cellView(forElement element: Element) -> some View {
        HStack {
            itemContent(element)
            
            if isEditMode {
                Image(systemName: selectedIDs.contains(element.id) ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
                    .padding()
            }
        }
        .cardify()
    }
    
    private var editView: some View {
        HStack {
            Button {
                viewModel.actionPublisher.send(.delete(IDs: selectedIDs))
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
    
    @ViewBuilder
    private var gridButtons: some View {
        if showGridButtons {
            HStack {
                ForEach(1...3, id: \.self) { columns in
                    Button(action: {
                        withAnimation {
                            self.columns = columns
                        }
                    }, label: {
                        Image(systemName: "rectangle.grid.\(columns)x2.fill")
                    })
                }
            }
        }
    }
    
    @ViewBuilder
    private var editButtons: some View {
        if showEditButtons {
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
}

//#Preview {
//    let viewModel = BaseLCEListViewModel<>(dataSource: )
//    BaseLCEListView(viewModel: viewModel) { object in
//        Text("")
//    }
//}
