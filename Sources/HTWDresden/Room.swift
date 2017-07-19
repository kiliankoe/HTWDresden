import Foundation

public struct Room: Codable {
    public let name: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.name = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.name)
    }
}
