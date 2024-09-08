import Foundation
import Combine

protocol UsersDataSource: DemoDataSource {
    func getRemoteUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DataError>
    func getLocalUsers() -> AnyPublisher<[User], DataError>
}
