import Foundation

enum StorageError: Error {
    case databaseError(error: Error)
}
