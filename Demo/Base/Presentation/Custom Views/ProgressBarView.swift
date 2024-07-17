import SwiftUI

struct ProgressBarView: View {
    typealias Border = (color: Color, width: CGFloat)
    
    private static let defaultBackgroundView = AnyView(Color.clear)
    private static let defaultForegroundView = AnyView(gradient(withColors: [Color.green, Color.blue]))
    private static let defaultAnimationDuration = 0.5
    
    private static func gradient(withColors colors: [Color]) -> LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
    }
    
    var value: Int
    var backgroundView: AnyView
    var foregroundView: AnyView
    var border: Border?
    var animationDuration: Double
    
    init(value: Int, backgroundColor: Color, foregroundColor: Color, border: Border? = nil, animationDuration: Double = ProgressBarView.defaultAnimationDuration) {
        self.init(value: value, backgroundView: AnyView(backgroundColor), foregroundView: AnyView(foregroundColor), animationDuration: animationDuration)
    }
    
    init(value: Int, backgroundColors: [Color], foregroundColors: [Color], border: Border? = nil, animationDuration: Double = ProgressBarView.defaultAnimationDuration) {
        let backgroundGradient = ProgressBarView.gradient(withColors: backgroundColors)
        let foregroundGradient = ProgressBarView.gradient(withColors: foregroundColors)
        self.init(value: value, backgroundView: AnyView(backgroundGradient), foregroundView: AnyView(foregroundGradient), animationDuration: animationDuration)
    }
    
    init(value: Int, backgroundView: AnyView = ProgressBarView.defaultBackgroundView, foregroundView: AnyView = ProgressBarView.defaultForegroundView, border: Border? = nil, animationDuration: Double = ProgressBarView.defaultAnimationDuration) {
        self.value = value
        self.backgroundView = backgroundView
        self.foregroundView = foregroundView
        self.border = border
        self.animationDuration = animationDuration
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(self.backgroundView)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .background(self.foregroundView)
                    .frame(width: geometry.size.width * CGFloat(self.value) / 100)
                    .animation(.linear(duration: self.animationDuration))
                
                if self.border != nil {
                    RoundedRectangle(cornerRadius: geometry.size.height / 2)
                        .stroke(self.border!.color, lineWidth: self.border!.width)
                }
            }
            .cornerRadius(geometry.size.height / 2)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        let values = [0, 25, 50, 75, 100]
        return ForEach(values, id: \.self) { value in
            ProgressBarView(value: value)
                .previewLayout(.fixed(width: 400, height: 40))
                .padding(10)
        }
    }
}
