import SwiftUI

struct ContentWrappingGeometryReader<Content>: View where Content: View {
    let content: (CGSize) -> Content
    @State private var size: CGSize = SizeKey.defaultValue
    
    var body: some View {
        content(size)
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(key: SizeKey.self, value: geometry.size)
                }
            )
            .onPreferenceChange(SizeKey.self) { size = $0 }
    }
}

private extension ContentWrappingGeometryReader {
    struct SizeKey: PreferenceKey {
        static var defaultValue: CGSize { .zero }
        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
}

#Preview {
    ContentWrappingGeometryReader { _ in
        Text("Hello World")
            .foregroundColor(.white)
            .background(Color.black)
    }
}
