import SwiftUI

struct CardView: ViewModifier {
    var backgroundColor: Color
    var cornerRadius: CGFloat
    var shadowColor: Color
    var shadowRadius: CGFloat
    var shadowOffset: CGPoint
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: shadowRadius, x: shadowOffset.x, y: shadowOffset.y)
    }
}

extension View {
    func cardify(backgroundColor: Color = .white, cornerRadius: CGFloat = 10, shadowColor: Color = .gray, shadowRadius: CGFloat = 10, shadowOffset: CGPoint = .zero) -> some View {
        modifier(CardView(backgroundColor: backgroundColor, cornerRadius: cornerRadius, shadowColor: shadowColor, shadowRadius: shadowRadius, shadowOffset: shadowOffset))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
            .font(.title)
            .padding()
            .cardify()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
