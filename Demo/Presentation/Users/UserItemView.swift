import SwiftUI

struct UserItemView: View {
    let user: User
    
    var body: some View {
        let info = [("Name:", user.name),
                    ("Email:", user.email),
                    ("Phone:", user.phone),
                    ("Address:", user.address?.description),
                    ("Website:", user.website),
                    ("Company:", user.company?.name)]
        
        return InfoView(info: info)
            .padding()
    }
}

#Preview {
    UserItemView(user: TestData.testUser)
}
