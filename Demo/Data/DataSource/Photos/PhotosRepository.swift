import Foundation
import Combine

class PhotosRepository: PhotosDataSource {
    let networkAgent: NetworkAgentProtocol
    var methodName: String { "photos" }
    
    init(networkAgent: NetworkAgentProtocol = NetworkAgent()) {
        self.networkAgent = networkAgent
    }
    
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
