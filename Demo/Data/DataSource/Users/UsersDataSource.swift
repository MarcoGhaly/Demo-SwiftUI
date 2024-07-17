import Foundation
import Combine

protocol UsersDataSource: DemoDataSource {
    func getRemoteUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAPIError>
    func getLocalUsers() -> AnyPublisher<[User], DefaultAPIError>
}
