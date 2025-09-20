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
                    HStack(alignment: .top) {
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

#Preview {
    let info = [
        ("Name:", "John Doe"),
        ("Email:", "john.doe@email.com"),
        ("Phone:", "012-345-6789"),
        ("Status", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua")
    ]
    InfoView(info: info)
}
