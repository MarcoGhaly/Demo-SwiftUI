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
        Future { promise in
            do {
                let queryParameters = queryParameters(from: albumID)
                let photos: [Photo] = try getLocalData(queryParameters: queryParameters)
                promise(.success(photos))
            } catch {
                promise(.failure(.localError(error: error)))
            }
        }.eraseToAnyPublisher()
    }
}

private extension PhotosRepository {
    func queryParameters(from albumID: Int?) -> [String: String] {
        var queryParameters = [String: String]()
        albumID.map { queryParameters["albumId"] = String($0) }
        return queryParameters
    }
}
