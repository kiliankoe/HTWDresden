import Foundation

public struct Course: Codable {
    public let degreeTxt: String
    public let regulationVersion: String
    public let degreeNumber: String
    public let number: String
    public let note: String

    private enum CodingKeys: String, CodingKey {
        case degreeTxt = "AbschlTxt"
        case regulationVersion = "POVersion"
        case degreeNumber = "AbschlNr"
        case number = "StgNr"
        case note = "StgTxt"
    }
}
