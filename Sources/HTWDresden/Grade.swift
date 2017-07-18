import Foundation

public struct Grade: Codable {
    public let number: String
    public let status: Status?
    public let ectsCredits: Double
    public let note: String
    public let semester: Semester?
    public let tryCount: Int
    public let date: Date?
    public let grade: Double // would it make sense to keep the grade in some other internal representation?
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
