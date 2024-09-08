import Foundation

enum DataError: Error {
    case remoteError(error: Error)
    case localError(error: Error)
}
