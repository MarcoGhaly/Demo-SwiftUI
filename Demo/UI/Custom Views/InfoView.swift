//
//  InfoView.swift
//  Demo
//
//  Created by Marco Ghaly on 27/11/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    let info: [(label: String, value: String?)]
    
    let labelFont = Font.subheadline
    let valueFont = Font.subheadline
    let labelColor = Color.black
    let valueColor = Color.black
    
    var body: some View {
        VStack {
            ForEach(info, id: \.label) { info in
                info.value.map { value in
                    HStack {
                        Text(info.label)
                            .font(labelFont)
                            .foregroundColor(labelColor)
                        
                        Text(value)
                            .font(valueFont)
                            .foregroundColor(valueColor)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        let info = [("Name:", "John Doe"),
                    ("Email:", "john.doe@email.com"),
                    ("Phone:", "012-345-6789")]
        return InfoView(info: info)
            .previewLayout(.sizeThatFits)
    }
}
