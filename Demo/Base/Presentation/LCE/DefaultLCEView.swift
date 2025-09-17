import SwiftUI

struct DefaultLCEView<Model, AppError, ViewModel, Content>: View
where ViewModel: LCEViewModel<Model, AppError>, Content: View {
    @ObservedObject var viewModel: ViewModel
    let content: (Model) -> Content
    
    init(viewModel: ViewModel, @ViewBuilder content: @escaping (Model) -> Content) {
        self.viewModel = viewModel
        self.content = content
    }
    
    var body: some View {
        LCEView(viewModel: viewModel) { model in
            content(model)
        } loading: { loadingViewModel in
            DefaultLoadingView(loadingViewModel: loadingViewModel)
        } error: { errorViewModel in
            DefaultErrorView(errorViewModel: errorViewModel)
        }
    }
}

#Preview {
    let loadingViewModel = LoadingViewModel(
        style: .normal,
        title: "Loading...",
        message: "Please Wait"
    )
    let errorViewModel = ErrorViewModel(
        image: (
            type: .system,
            name: "multiply.circle",
            mode: .original
        ),
        title: "Error!",
        message: "An Error Occurred",
        retry: (
            label: "Retry",
            action: {}
        )
    )
    let states: [LCEViewModel<String, Error>.ViewState] = [
        .loading(model: loadingViewModel),
        .error(model: errorViewModel),
        .content
    ]
    ForEach(states.indices, id: \.self) { index in
        getDefaultLCEView(state: states[index])
    }
    .previewLayout(.fixed(width: 400, height: 150))
}

private func getDefaultLCEView(state: LCEViewModel<String, Error>.ViewState) -> DefaultLCEView<String, Error, LCEViewModel<String, Error>, Text> {
    let viewModel = LCEViewModel<String, Error>()
    viewModel.model = "Content"
    viewModel.viewState = state
    return DefaultLCEView(viewModel: viewModel) { model in
        Text(model)
            .font(.largeTitle)
    }
}
