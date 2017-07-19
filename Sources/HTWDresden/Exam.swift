import Foundation

public struct Exam: Codable {
    public let title: String
    public let type: String // this seems a bit too complex to parse as an enum? What possible values are there anyways?
    public let studyBranch: String
    public let day: String
    public let startTime: String
    public let endTime: String
    public let examiners: [String]
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
        case examiners = "Examiner"
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
        self.examiners = try container.decode(String.self, forKey: .examiners)
            .split(separator: "/")
            .map(String.init)
            .map { $0.trimmingCharacters(in: .whitespaces) }
        self.nextChance = try container.decode(String.self, forKey: .nextChance)
        self.rooms = try container.decode([String].self, forKey: .rooms)
    }
}

extension Exam: APIResource {
    static var url: URL {
        return URL(string: "https://www2.htw-dresden.de/~app/API/GetExams.php")!
    }

    internal static func get(with params: [String: String], session: URLSession, completion: @escaping (Result<[Exam]>) -> Void) {
        let url = URL(string: "?\(params.urlEncoded)", relativeTo: self.url)!
        let request = URLRequest(url: url)
        Network.dataTask(request: request, session: session, completion: completion)
    }

    public static func forStudent(year: Int, courseID: Int, degree: Degree, session: URLSession = .shared, completion: @escaping (Result<[Exam]>) -> Void) {
        let params = [
            "StgJhr": String(year),
            "Stg": String(courseID),
            "AbSc": degree.rawValue
        ]
        self.get(with: params, session: session, completion: completion)
    }

    public static func forStudygroup(with studygroup: Studygroup, session: URLSession = .shared, completion: @escaping (Result<[Exam]>) -> Void) {
        self.forStudent(year: studygroup.year, courseID: studygroup.courseID, degree: studygroup.degree, completion: completion)
    }

    public static func forProfessor(with id: String, session: URLSession = .shared, completion: @escaping (Result<[Exam]>) -> Void) {
        let params = ["Prof": id]
        self.get(with: params, session: session, completion: completion)
    }
}
