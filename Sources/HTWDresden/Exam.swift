import Foundation

public struct Exam: Codable {
    public let title: String
    public let type: String // this seems a bit too complex to parse as an enum? What possible values are there anyways?
    public let studyBranch: String
    public let day: String
    public let startTime: String
    public let endTime: String
    public let examiner: [String]
    public let nextChance: String
    public let rooms: [String]

    /// Convenience getter for an actual date value including `day` and `startTime`.
    public var date: Date? {
        return Date(withDayString: self.day, andTimeString: self.startTime)
    }

    /// Convenience getter for the time interval between `startTime` and `endTime`.
    public var duration: TimeInterval? {
        guard let date = self.date else { return nil }
        return date.distance(toTimeString: self.endTime)
    }

    private enum CustomCodingKeys: String, CodingKey {
        case title = "Title"
        case type = "ExamType"
        case studyBranch = "StudyBranch"
        case day = "Day"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case examiner = "Examiner"
        case nextChance = "NextChance"
        case rooms = "Rooms"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decode(String.self, forKey: .type)
        self.studyBranch = try container.decode(String.self, forKey: .studyBranch)
        self.day = try container.decode(String.self, forKey: .day)
        self.startTime = try container.decode(String.self, forKey: .startTime)
        self.endTime = try container.decode(String.self, forKey: .endTime)
        self.examiner = try container.decode(String.self, forKey: .examiner)
            .split(separator: "/")
            .map(String.init)
            .map { $0.trimmingCharacters(in: .whitespaces) }
        self.nextChance = try container.decode(String.self, forKey: .nextChance)
        self.rooms = try container.decode([String].self, forKey: .rooms)
    }
}

private extension Date {
    init?(withDayString dayString: String, andTimeString timeString: String) {
        let dayStringComponents = dayString.components(splitBy: ".")
        guard dayStringComponents.count > 1 else { return nil }

        let timeStringComponents = timeString.components(splitBy: ":")
        guard timeStringComponents.count == 2 else { return nil }

        let (day, month) = (dayStringComponents[0], dayStringComponents[1])
        let (hour, minute) = (timeStringComponents[0], timeStringComponents[1])

        let year: Int
        if dayStringComponents.count == 3 {
            year = dayStringComponents[2]
        } else {
            year = Date.currentYear
        }

        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        guard let date = Calendar.current.date(from: components) else { return nil }
        self = date
    }

    static var currentYear: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: Date())
    }

    func distance(toTimeString timeString: String) -> TimeInterval? {
        let timeStringComponents = timeString.components(splitBy: ":")
        guard timeStringComponents.count == 2 else { return nil }
        let (hour, minute) = (timeStringComponents[0], timeStringComponents[1])
        let selfComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: DateComponents(year: selfComponents.year, month: selfComponents.month, day: selfComponents.day, hour: hour, minute: minute))
        return date?.timeIntervalSince(self)
    }
}

private extension String {
    func components(splitBy separator: Character) -> [Int] {
        return self
            .split(separator: separator)
            .map(String.init)
            .flatMap { Int($0) }
    }
}
