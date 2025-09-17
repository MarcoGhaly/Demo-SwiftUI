import SwiftUI

struct UserRowView: View {
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

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        return UserRowView(user: TestData.testUser)
            .previewLayout(.sizeThatFits)
    }
}
