import Foundation

public struct Grade: Decodable {
    public let identifier: String
    public let status: Status?
    public let ectsCredits: Double
    public let name: String
    public let semester: Semester?
    public let tryCount: Int
    public let date: Date?
    public let grade: Int? // would it make sense to keep the grade in some other internal representation?
    public let publishDate: Date?
    public let kind: String // this would make sense as an enum as well, I've seen 'G', 'S', 'U', 'AP'
    public let annotation: Annotation?
    public let ectsGrade: String? // what is this actually? and what type? Double probably?

    private enum CodingKeys: String, CodingKey {
        case identifier = "PrNr"
        case status = "Status"
        case ectsCredits = "EctsCredits"
        case name = "PrTxt"
        case semester = "Semester"
        case tryCount = "Versuch"
        case date = "PrDatum"
        case grade = "PrNote"
        case publishDate = "VoDatum"
        case kind = "PrForm"
        case annotation = "Vermerk"
        case ectsGrade = "EctsGrade"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.status = try container.decodeIfPresent(Status.self, forKey: .status)
        let rawEctsCredits = try container.decode(String.self, forKey: .ectsCredits)
        guard let ectsCredits = Double(rawEctsCredits) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.ectsCredits], debugDescription: "Did not find expected double string value"))
        }
        self.ectsCredits = ectsCredits
        self.name = try container.decode(String.self, forKey: .name)
        self.semester = try container.decodeIfPresent(Semester.self, forKey: .semester)
        let rawTryCount = try container.decode(String.self, forKey: .tryCount)
        guard let tryCount = Int(rawTryCount) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.tryCount], debugDescription: "Did not find expected int string value"))
        }
        self.tryCount = tryCount
        let rawDate = try container.decodeIfPresent(String.self, forKey: .date)
        if let rawDate = rawDate {
            self.date = Date(withDayString: rawDate)
        } else {
            self.date = nil
        }
        let rawGrade = try container.decodeIfPresent(String.self, forKey: .grade)
        if let rawGrade = rawGrade {
            self.grade = Int(rawGrade)
        } else {
            self.grade = nil
        }
        let rawPublishDate = try container.decodeIfPresent(String.self, forKey: .publishDate)
        if let rawPublishDate = rawPublishDate {
            self.publishDate = Date(withDayString: rawPublishDate)
        } else {
            self.publishDate = nil
        }
        self.kind = try container.decode(String.self, forKey: .kind)
        let rawAnnotation = try container.decodeIfPresent(String.self, forKey: .annotation)
        if let rawAnnotation = rawAnnotation, rawAnnotation != "" {
            self.annotation = Annotation(rawValue: rawAnnotation)
        } else {
            self.annotation = nil
        }
        let rawEctsGrade = try container.decodeIfPresent(String.self, forKey: .ectsGrade)
        if let rawEctsGrade = rawEctsGrade, rawEctsGrade != "" {
            self.ectsGrade = rawEctsGrade
        } else {
            self.ectsGrade = nil
        }
    }
}

extension Grade {
    public enum Status: String, Codable {
        case signedUp = "AN"
        case passed = "BE"
        case failed = "NB"
        case ultimatelyFailed = "EN"
    }
}

extension Grade.Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case .signedUp: return "Angemeldet"
        case .passed: return "Bestanden"
        case .failed: return "Nicht bestanden"
        case .ultimatelyFailed: return "Endgültig nicht bestanden"
        }
    }
}

extension Grade {
    public enum Annotation: String, Codable {
        case accreddited = "a"
        case sick = "k"
        case signedOut = "e"
        case blocked = "g"
        case notPermitted = "nz"
        case unexcusedAbsence = "5ue"
        case notReported = "5na"
        case noSecondAttemptApplication = "kA"
        case freeAtempt = "PFV"
        case withSuccess = "mE"
        case failed = "N"
        case openPracticalCourse = "VPo"
        case noShowOptionalAppointment = "f"
        case withReservation = "uV"
    }
}

extension Grade.Annotation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .accreddited: return "anerkannt"
        case .sick: return "krank"
        case .signedOut: return "abgemeldet"
        case .blocked: return "gesperrt"
        case .notPermitted: return "nicht zugelassen"
        case .unexcusedAbsence: return "unentschuldigt gefehlt"
        case .notReported: return "nicht angetreten - Fristüberschreitung"
        case .noSecondAttemptApplication: return "kein Antrag 2. Wiederholungsprüfung gestellt"
        case .freeAtempt: return "Freiversuch"
        case .withSuccess: return "mit Erfolg"
        case .failed: return "nicht bestanden"
        case .openPracticalCourse: return "Vorpraktikum offen"
        case .noShowOptionalAppointment: return "freiwilliger Termin nicht wahrgenommen"
        case .withReservation: return "unter Vorbehalt"
        }
    }
}

extension Grade: APIResource {
    static var url: URL {
        return URL(string: "https://wwwqis.htw-dresden.de/appservice/getgrades")!
    }

    public static func get(for login: Login, degreeNumber: String, courseNumber: String, regulationVersion: String, session: URLSession = .shared, completion: @escaping (Result<[Grade]>) -> Void) {
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        let body = ["sNummer": login.sNumber, "RZLogin": login.password, "AbschlNr": degreeNumber, "StgNr": courseNumber, "POVersion": regulationVersion]
        request.httpBody = body.urlEncoded.data(using: .utf8)
        Network.dataTask(request: request, session: session, completion: completion)
    }

    public static func get(for login: Login, course: Course, session: URLSession = .shared, completion: @escaping (Result<[Grade]>) -> Void) {
        self.get(for: login, degreeNumber: course.degreeNumber, courseNumber: course.number, regulationVersion: course.regulationVersion, session: session, completion: completion)
    }
}
