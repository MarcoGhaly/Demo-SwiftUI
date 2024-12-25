import Foundation
import Combine

struct PhotosRepository: PhotosDataSource {
    let methodName = "photos"
    
    var networkAgent: NetworkAgentProtocol = NetworkAgent()
    var databaseManager: DatabaseManagerProtocol = DatabaseManager()

    func getRemotePhotos(albumID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Photo], DataError> {
        let queryParameters = queryParameters(from: albumID)
        return getRemoteData(queryParameters: queryParameters, page: page, limit: limit)
    }
    
    func getLocalPhotos(albumID: Int?) -> AnyPublisher<[Photo], DataError> {
        let queryParameters = queryParameters(from: albumID)
        return getLocalData(queryParameters: queryParameters)
    }
}

private extension PhotosRepository {
    func queryParameters(from albumID: Int?) -> [String: String] {
        var queryParameters = [String: String]()
        albumID.map { queryParameters["albumId"] = String($0) }
        return queryParameters
    }
}
