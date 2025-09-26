import Foundation

enum TestData {
    static let testUser = User(
        id: 1,
        name: "Leanne Graham",
        username: "Bret",
        email: "Sincere@april.biz",
        address: Address(
            street: "Kulas Light",
            suite: "Apt. 556",
            city: "Gwenborough",
            zipcode: "92998-3874",
            geo: Geo(
                lat: "-37.3159",
                lng: "81.1496"
            )
        ),
        phone: "1-770-736-8031 x56442",
        website: "hildegard.org",
        company: Company(
            name: "Romaguera-Crona",
            catchPhrase: "Multi-layered client-server neural-net",
            bs: "harness real-time e-markets"
        )
    )
    
    static let testPost = Post(
        userId: 1,
        id: 1,
        title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        body: """
            quia et suscipit
            suscipit recusandae consequuntur expedita et cum
            reprehenderit molestiae ut ut quas totam
            nostrum rerum est autem sunt rem eveniet architecto
            """
    )
    
    static let testComment = Comment(
        postId: 1,
        id: 1,
        name: "id labore ex et quam laborum",
        email: "Eliseo@gardner.biz",
        body: """
            laudantium enim quasi est quidem magnam voluptate ipsam eos
            tempora quo necessitatibus
            dolor quam autem quasi
            reiciendis et nam sapiente accusantium
            """
    )
    
    static let testToDo = ToDo(
        userId: 1,
        id: 1,
        title: "delectus aut autem",
        completed: true
    )
    
    static let testAlbum = Album(
        id: 1,
        userId: 1,
        title: "quidem molestiae enim"
    )
    
    static let testPhoto = Photo(
        albumId: 1,
        id: 1,
        title: "accusamus beatae ad facilis cum similique qui sunt",
        url: "https://via.placeholder.com/600/92c952",
        thumbnailUrl: "https://via.placeholder.com/150/92c952"
    )
}
