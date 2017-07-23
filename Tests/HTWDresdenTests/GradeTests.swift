import XCTest
@testable import HTWDresden

class GradeTests: XCTestCase {
    func testDeserialization() {
        let json = """
        [
            {
                "PrNr": "721211300",
                "Status": "BE",
                "EctsCredits": "6.0",
                "PrTxt": "Informatik 1",
                "Semester": "20162",
                "Versuch": "1",
                "PrDatum": "15.02.2017",
                "PrNote": "100",
                "VoDatum": "13.06.2017",
                "PrForm": "S",
                "Vermerk": "",
                "EctsGrade": ""
            },
            {
                "PrNr": "721211400",
                "Status": "BE",
                "EctsCredits": "6.0",
                "PrTxt": "Mathematik 1",
                "Semester": "20162",
                "Versuch": "1",
                "PrDatum": "",
                "PrNote": "130",
                "VoDatum": "",
                "PrForm": "G",
                "Vermerk": "",
                "EctsGrade": ""
            }
        ]
        """.data(using: .utf8)!

        let grades = try! JSONDecoder().decode([Grade].self, from: json)
        XCTAssertEqual(grades[0].examName, "Informatik 1")
        XCTAssertEqual(grades[0].status, .passed)
        XCTAssertEqual(grades[1].grade, 130)
    }

    static var allTests = [
        ("testDeserialization", testDeserialization)
    ]
}
