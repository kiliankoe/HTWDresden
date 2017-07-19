import Foundation

public struct SemesterPlan: Codable {
    let year: Int
    let kind: Kind
    let period: Period
    let freeDays: [Holiday]
    let lecturePeriod: Period
    let examPeriod: Period
    let reregistration: Period
}

extension SemesterPlan {
    public enum Kind: String, Codable {
        case winter = "W"
        case summer = "S"
    }

    public struct Period: Codable {
        public let begin: Date
        public let end: Date

        private enum CodingKeys: String, CodingKey {
            case begin = "beginDay"
            case end = "endDay"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let beginStr = try container.decode(String.self, forKey: .begin)
            let endStr = try container.decode(String.self, forKey: .end)
            guard
                let begin = Date(withShortISO: beginStr),
                let end = Date(withShortISO: endStr)
            else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.begin, CodingKeys.end], debugDescription: "Date values were not of the expected format 'yyyy-MM-dd'."))
            }
            self.begin = begin
            self.end = end
        }
    }

    public struct Holiday: Codable {
        public let name: String
        public let begin: Date
        public let end: Date

        private enum CodingKeys: String, CodingKey {
            case name
            case begin = "beginDay"
            case end = "endDay"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            let beginStr = try container.decode(String.self, forKey: .begin)
            let endStr = try container.decode(String.self, forKey: .end)
            guard
                let begin = Date(withShortISO: beginStr),
                let end = Date(withShortISO: endStr)
            else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.begin, CodingKeys.end], debugDescription: "Date values were not of the expected format 'yyyy-MM-dd'."))
            }
            self.begin = begin
            self.end = end
        }
    }
}
