//
//  HintsScrollView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/4/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct HintsScrollView<Content: View, HintView: View>: View {
    
    enum ScrollState {
        case top
        case middle
        case bottom
    }
    
    @State private var scrollState = ScrollState.middle
    
    var content: Content
    var hintView: HintView
    var scrollStates: [ScrollState]
    
    init(@ViewBuilder content: @escaping () -> Content, hintView: @escaping () -> HintView, scrollStates: [ScrollState] = [.top, .bottom]) {
        self.content = content()
        self.hintView = hintView()
        self.scrollStates = scrollStates
    }
    
    var body: some View {
        return ZStack {
            GeometryReader { outerGeometry in
                ScrollView {
                    VStack(spacing: 0) {
                        if self.scrollStates.contains(.top) {
                            GeometryReader { topGeometry -> Text in
                                DispatchQueue.main.async {
                                    let offset = topGeometry.frame(in: .global).maxY - outerGeometry.frame(in: .global).minY
                                    if offset >= 0 {
                                        self.scrollState = .top
                                    } else if self.scrollState == .top {
                                        self.scrollState = .middle
                                    }
                                }
                                return Text("")
                            }
                            .frame(height: 0)
                        }
                        
                        self.content
                        
                        if self.scrollStates.contains(.bottom) {
                            GeometryReader { bottomGeometry -> Text in
                                DispatchQueue.main.async {
                                    let offset = bottomGeometry.frame(in: .global).minY - outerGeometry.frame(in: .global).maxY
                                    if offset <= 0 {
                                        self.scrollState = .bottom
                                    } else if self.scrollState == .bottom {
                                        self.scrollState = .middle
                                    }
                                }
                                return Text("")
                            }
                            .frame(height: 0)
                        }
                    }
                }
            }
            
            VStack {
                if scrollState != .top && self.scrollStates.contains(.top) {
                    hintView
                }
                Spacer()
                if scrollState != .bottom && self.scrollStates.contains(.bottom) {
                    hintView
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
}

struct HintsScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HintsScrollView(content: {
            ForEach(0..<5) { _ in
                Text("Hello World")
                    .frame(height: 200)
                    .background(Color.green)
            }
        }, hintView: {
            Text("Scroll To Continue")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color.white)
        }, scrollStates: [.top, .bottom])
    }
}
