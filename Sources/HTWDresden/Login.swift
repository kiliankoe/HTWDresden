import Foundation

public struct Login {
    public let sNumber: String
    public let password: String

    public init(sNumber: UInt, password: String) {
        self.sNumber = "s\(sNumber)"
        self.password = password
    }
}
