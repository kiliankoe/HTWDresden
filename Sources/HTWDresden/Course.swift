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

    public static func get(for login: Login, session: URLSession = .shared, completion: @escaping (Result<[Course]>) -> Void) {
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        let body = ["sNummer": login.sNumber, "RZLogin": login.password]
        request.httpBody = body.urlEncoded.data(using: .utf8)
        Network.dataTask(request: request, session: session, completion: completion)
    }
}

extension Course: APIResource {
    static var url: URL {
        return URL(string: "https://wwwqis.htw-dresden.de/appservice/getcourses")!
    }
}
