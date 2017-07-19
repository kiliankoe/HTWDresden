import Foundation

public struct Grade: Decodable {
    public let number: String
    public let status: Status?
    public let ectsCredits: Double
    public let note: String
    public let semester: Semester?
    public let tryCount: Int
    public let date: Date?
    public let grade: Int? // would it make sense to keep the grade in some other internal representation?
    public let publishDate: Date?
    public let kind: String // this would make sense as an enum as well, I've seen 'G', 'S', 'U', 'AP'
    public let annotation: Annotation?
    public let ectsGrade: String? // what is this actually? and what type? Double probably?

    private enum CodingKeys: String, CodingKey {
        case number = "PrNr"
        case status = "Status"
        case ectsCredits = "EctsCredits"
        case note = "PrTxt"
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
        self.number = try container.decode(String.self, forKey: .number)
        self.status = try container.decodeIfPresent(Status.self, forKey: .status)
        let rawEctsCredits = try container.decode(String.self, forKey: .ectsCredits)
        guard let ectsCredits = Double(rawEctsCredits) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.ectsCredits], debugDescription: "Did not find expected double string value"))
        }
        self.ectsCredits = ectsCredits
        self.note = try container.decode(String.self, forKey: .note)
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
        case accreddited = "a" // anerkannt
        case sick = "k" // krank
        case signedOut = "e" // abgemeldet
        case blocked = "g" // gesperrt
        case notPermitted = "nz" // nicht zugelassen
        case unexcusedAbsence = "5ue" // unentschuldigt gefehlt
        case notReported = "5na" // nicht angetreten - Fristüberschreitung
        case noSecondAttemptApplication = "kA" // kein Antrag 2. Wiederholungsprüfung gestellt
        case freeAtempt = "PFV" // Freiversuch
        case withSuccess = "mE" // mit Erfolg
        case failed = "N" // nicht bestanden
        case openPracticalCourse = "VPo" // Vorpraktikum offen
        case noShowOptionalAppointment = "f" // freiwilliger Termin nicht wahrgenommen
        case withReservation = "uV" // unter Vorbehalt
    }
}
