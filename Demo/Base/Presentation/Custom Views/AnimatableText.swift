import SwiftUI

struct AnimatableText: View {
    var number: String
    var animationDuration = 0.5
    @State private var value = 0
    
    var body: some View {
        var animate = false
        if let number = Int(self.number) {
            animate = true
            DispatchQueue.main.async {
                withAnimation(.linear(duration: self.animationDuration)) {
                    self.value = number
                }
            }
        } else {
            DispatchQueue.main.async {
                self.value = 0
            }
        }
        
        return Text(number)
            .if(animate) { $0.modifier(TextAnimator(number: value)) }
    }
}

private struct TextAnimator: AnimatableModifier {
    var number = 0

    var animatableData: CGFloat {
        get { CGFloat(number) }
        set { number = Int(newValue) }
    }

    func body(content: Content) -> some View {
        Text("\(number)")
    }
}

struct AnimatableText_Previews: PreviewProvider {
    static var previews: some View {
        AnimatableText(number: "0")
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
