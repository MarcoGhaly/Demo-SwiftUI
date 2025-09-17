import SwiftUI

struct GridView<Element, Content>: View where Content: View {
    private static var defaultSpacing: CGFloat { 10 }
    
    private let elements: [Element]
    private let rows: Int
    private let columns: Int
    private let spacing: CGFloat
    private let content: (Element) -> Content
    
    private init(elements: [Element], rows: Int, columns: Int, spacing: CGFloat, @ViewBuilder content: @escaping (Element) -> Content) {
        self.elements = elements
        self.rows = rows
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
    
    init(elements: [Element], rows: Int, spacing: CGFloat = defaultSpacing, @ViewBuilder content: @escaping (Element) -> Content) {
        self.init(elements: elements, rows: rows, columns: elements.count / rows, spacing: spacing, content: content)
    }
    
    init(elements: [Element], columns: Int, spacing: CGFloat = defaultSpacing, @ViewBuilder content: @escaping (Element) -> Content) {
        self.init(elements: elements, rows: elements.count / columns, columns: columns, spacing: spacing, content: content)
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<rows) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<columns) { column in
                        let element = elements[columns * row + column]
                        content(element)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
    }
}

#Preview {
    GridView(elements: Array(repeating: "😃", count: 25), rows: 5) { emoji in
        Text(emoji)
            .font(.largeTitle)
    }
}
