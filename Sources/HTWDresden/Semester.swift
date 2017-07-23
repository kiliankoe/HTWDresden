import Foundation

public enum Semester: Codable {
    case winter(Int)
    case summer(Int)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let semesterString = try container.decode(String.self)
        let semesterId = String(semesterString.dropFirst(4))
        guard let year = Int(String(semesterString.dropLast())) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "\(semesterString.dropLast()) could not be parsed as an Integer"))
        }
        guard year > 1000 else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "\(year) does not seem to be a valid year. Expected four digits."))
        }
        switch semesterId {
        case "1":
            self = .summer(year)
        case "2":
            self = .winter(year)
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "\(semesterId) is not a valid semester identifier. Expected either '1' or '2'."))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .summer(let year):
            try container.encode("\(year)1")
        case .winter(let year):
            try container.encode("\(year)2")
        }
    }

    public static var current: Semester? {
        let components = Calendar(identifier: .gregorian).dateComponents([.year, .month], from: Date())
        guard let month = components.month, let year = components.year else { return nil }
        switch month {
        case 0...2:
            return .winter(year - 1)
        case 3...8:
            return .summer(year)
        default:
            return .winter(year)
        }
    }
}

extension Semester: CustomStringConvertible {
    public var description: String {
        switch self {
        case .winter(let year):
            return "WS \(year)/\(year+1)"
        case .summer(let year):
            return "SS \(year)"
        }
    }
}
