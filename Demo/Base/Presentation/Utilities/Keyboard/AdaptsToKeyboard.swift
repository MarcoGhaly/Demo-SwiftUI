import SwiftUI
import Combine

struct AdaptsToKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = .zero
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight)
                .onAppear {
                    publisher(from: UIResponder.keyboardWillShowNotification)
                        .merge(with: publisher(from: UIResponder.keyboardWillChangeFrameNotification))
                        .compactMap { notification in
                            withAnimation(.easeOut(duration: 0.16)) {
                                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                            }
                        }
                        .map { rect in
                            rect.height - geometry.safeAreaInsets.bottom
                        }
                        .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                    
                    publisher(from: UIResponder.keyboardWillHideNotification)
                        .compactMap { notification in
                            CGFloat.zero
                        }
                        .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                }
        }
    }
}

private extension AdaptsToKeyboard {
    func publisher(from notificationName: NSNotification.Name) -> NotificationCenter.Publisher {
        NotificationCenter.Publisher(center: NotificationCenter.default, name: notificationName)
    }
}

extension View {
    func adaptsToKeyboard() -> some View {
        return modifier(AdaptsToKeyboard())
    }
}
