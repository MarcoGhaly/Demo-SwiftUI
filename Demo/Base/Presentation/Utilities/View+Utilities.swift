import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifLet<Object: Any, Transform: View>(_ optional: Object?, transform: (Object, Self) -> Transform) -> some View {
        if let object = optional {
            transform(object, self)
        } else {
            self
        }
    }
    
    func toAnyView() -> AnyView { AnyView(self) }
    
    func navigationLink<Destination: View>(destination: Destination) -> NavigationLink<Self, Destination> {
        NavigationLink(destination: destination) { self }
    }
}
