import Foundation

public struct Lesson: Codable {
    public let tag: String
    public let name: String
    public let kind: Kind
    public let week: Week
    public let day: Day
    public let begin: String
    public let end: String
    public let lecturer: String
    public let weeksOnly: String
    public let rooms: [String]

    public var beginTime: Time? {
        return Time(from: self.begin)
    }

    public var endTime: Time? {
        return Time(from: self.end)
    }

    public var timeSlot: Int? {
        guard let beginTime = self.beginTime else { return nil }
        switch (beginTime.hour, beginTime.minute) {
        case (7, 30): return 1
        case (9, 20): return 2
        case (11, 10): return 3
        case (13, 20): return 4
        case (15, 10): return 5
        case (17, 00): return 6
        case (18, 50): return 7
        case (20, 40): return 8
        default: return nil
        }
    }

    // TODO: Add a convenience getter for the duration TimeInterval

    private enum CodingKeys: String, CodingKey {
        case tag = "lessonTag"
        case name
        case kind = "type"
        case week
        case day
        case begin = "beginTime"
        case end = "endTime"
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

    public struct Time {
        public let hour: UInt
        public let minute: UInt
        public let second: UInt

        init?(from timeString: String) {
            let components = timeString.components(splitBy: ":")
            guard components.count >= 2 else { return nil }
            self.hour = UInt(components[0])
            self.minute = UInt(components[1])
            if components.count == 3 {
                self.second = UInt(components[2])
            } else {
                self.second = 0
            }
        }
    }
}
