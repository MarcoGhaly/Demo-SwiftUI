import SwiftUI

struct LCEView<Model, AppError, ViewModel, Content, Loading, Error>: View
where ViewModel: LCEViewModel<Model, AppError>, Content: View, Loading: LoadingView, Error: ErrorView {
    @ObservedObject var viewModel: ViewModel
    let content: (Model) -> Content
    let loading: (LoadingViewModel) -> Loading
    let error: (ErrorViewModel) -> Error
    
    init(viewModel: ViewModel, @ViewBuilder content: @escaping (Model) -> Content, @ViewBuilder loading: @escaping (LoadingViewModel) -> Loading, @ViewBuilder error: @escaping (ErrorViewModel) -> Error) {
        self.viewModel = viewModel
        self.content = content
        self.loading = loading
        self.error = error
    }
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .content:
                contentView
            case .loading(let loadingViewModel):
                if loadingViewModel.style == .dialog {
                    contentView
                }
                loading(loadingViewModel)
            case .error(let errorViewModel):
                error(errorViewModel)
            }
        }
    }
    
    var contentView: some View {
        viewModel.model.map { model in
            content(model)
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
        getLCEView(state: states[index])
    }
    .previewLayout(.fixed(width: 400, height: 150))
}

private func getLCEView(state: LCEViewModel<String, Error>.ViewState) -> LCEView<String, Error, LCEViewModel<String, Error>, Text, DefaultLoadingView, DefaultErrorView> {
    let viewModel = LCEViewModel<String, Error>()
    viewModel.model = "Content"
    viewModel.viewState = state
    return LCEView(viewModel: viewModel) { model in
        Text(model)
            .font(.largeTitle)
    } loading: { loadingViewModel in
        DefaultLoadingView(loadingViewModel: loadingViewModel)
    } error: { errorViewModel in
        DefaultErrorView(errorViewModel: errorViewModel)
    }
}
