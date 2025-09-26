import SwiftUI

struct UserItemView: View {
    let user: User
    
    var body: some View {
        InfoView(info: info)
            .padding()
    }
}

private extension UserItemView {
    var info: [(label: String, value: String?)] {
        [
            ("Name:", user.name),
            ("Email:", user.email),
            ("Phone:", user.phone),
            ("Address:", user.address?.description),
            ("Website:", user.website),
            ("Company:", user.company?.name)
        ]
    }
}

#Preview {
    UserItemView(user: TestData.testUser)
}
