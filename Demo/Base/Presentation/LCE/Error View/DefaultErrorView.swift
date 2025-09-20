import SwiftUI

struct DefaultErrorView: ErrorView {
    private let padding: CGFloat = 25
    private let spacing: CGFloat = 15
    private let iconDimension: CGFloat = 50
    
    var errorViewModel: ErrorViewModel
    
    var body: some View {
        VStack(spacing: spacing) {
            errorViewModel.image.map { image in
                (image.type == .normal ? Image(image.name) : Image(systemName: image.name))
                    .if(image.mode == .icon) {
                        $0.resizable()
                            .frame(width: iconDimension, height: iconDimension)
                    }
            }
            
            errorViewModel.title.map { title in
                Text(title)
                    .font(.title)
            }
            
            errorViewModel.message.map { message in
                Text(message)
                    .font(.body)
            }
            
            errorViewModel.retry.map { retry in
                Button(retry.label, action: retry.action)
            }
        }
        .padding(padding)
    }
}

#Preview {
    let errorViewModel = ErrorViewModel(
        image: (
            type: .system,
            name: "multiply.circle",
            mode: .icon
        ),
        title: "Error Title",
        message: "Error Message",
        retry: (
            label: "Retry",
            action: {}
        )
    )
    DefaultErrorView(errorViewModel: errorViewModel)
}
