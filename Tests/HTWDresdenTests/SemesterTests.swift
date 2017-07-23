import XCTest
@testable import HTWDresden

class SemesterTests: XCTestCase {
    func testDeserialization() {
        let decoder = JSONDecoder()
        let json = """
        [
            "20171",
            "20162",
            "20181",
            "19992"
        ]
        """.data(using: .utf8)!

        let semesters = try! decoder.decode([Semester].self, from: json)
        XCTAssertEqual(semesters[0].description, "SS 2017")
        XCTAssertEqual(semesters[1].description, "WS 2016/2017")
        XCTAssertEqual(semesters[2].description, "SS 2018")
        XCTAssertEqual(semesters[3].description, "WS 1999/2000")

        let invalidYearJSON = "[\"2351\"]".data(using: .utf8)!
        do {
            let _ = try decoder.decode([Semester].self, from: invalidYearJSON)
            XCTFail("Invalid year should not succeed.")
        }
        catch {
            // All good
        }

        let invalidSemesterId = "[\"20170\"]".data(using: .utf8)!
        do {
            let _ = try decoder.decode([Semester].self, from: invalidSemesterId)
            XCTFail("Invalid semester identifier should not succeed.")
        }
        catch {
            // All good
        }
    }

    func testCurrent() {
        // TODO: Figure out a sensible way of testing this.
        guard let current = Semester.current else {
            XCTFail("Semester.current should return a value.")
            return
        }
        print(current)
    }

    static var allTests = [
        ("testDeserialization", testDeserialization),
        ("testCurrent", testCurrent)
    ]
}
