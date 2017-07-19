import Foundation

public struct Lesson: Codable {
    public let tag: String
    public let name: String
    public let kind: Kind
    public let week: Week
    public let day: Day
    public let beginTime: String
    public let endTime: String
    public let lecturer: String
    public let weeksOnly: String
    public let rooms: [String]

    // TODO: Add a convenience getter for the duration TimeInterval

    private enum CodingKeys: String, CodingKey {
        case tag = "lessonTag"
        case name
        case kind = "type"
        case week
        case day
        case beginTime
        case endTime
        case lecturer = "professor"
        case weeksOnly = "WeeksOnly"
        case rooms = "Rooms"
    }
}

extension Lesson {
    // TODO: there's probably more cases here...
    public enum Kind: String, Codable {
        case lecture = "V"
        case tutorium = "Ü"
        case practicalCourse = "Pr"
        case unknown = ""
        case other

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            if let kind = Kind(rawValue: value) {
                self = kind
                return
            }
            print("Found unknown Lesson.Kind: '\(value)'")
            print("Please add this to the enum here -> https://github.com/kiliankoe/HTWDresden/blob/master/Sources/HTWDresden/Lesson.swift")
            self = .other
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            guard self != .other else {
                throw EncodingError.invalidValue(Kind.other, EncodingError.Context(codingPath: [nil], debugDescription: "Lesson.Kind.other is not a valid value to serialize"))
            }
            try container.encode(self.rawValue)
        }
    }

    public enum Week: Int, Codable {
        case even
        case odd
    }

    public enum Day: Int, Codable {
        case monday = 1
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
}
