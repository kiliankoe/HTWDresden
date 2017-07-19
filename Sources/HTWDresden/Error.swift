import Foundation

public enum Error: Swift.Error {
    case network
    case server(statusCode: Int)
}
