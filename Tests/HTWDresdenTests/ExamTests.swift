import XCTest
@testable import HTWDresden

class ExamTests: XCTestCase {
    func testDeserialization() {
        let json = """
        [
            {
                "Title": "E012  Gerätekonstruktion / Werkstofftechnik",
                "ExamType": "SP N/W",
                "StudyBranch": "",
                "Day": "21.07.",
                "StartTime": "15:30",
                "EndTime": "17:00",
                "Examiner": "R.Bauer / A.Gorbunoff",
                "NextChance": "",
                "Rooms": [
                    "S 331"
                ]
            },
            {
                "Title": "I901  Informatik 1",
                "ExamType": "SP N/W",
                "StudyBranch": "",
                "Day": "11.07.",
                "StartTime": "12:30",
                "EndTime": "14:30",
                "Examiner": "P.Sobe",
                "NextChance": "",
                "Rooms": [
                    "S 239"
                ]
            },
            {
                "Title": "E010  Elektrotechnik 1",
                "ExamType": "SP N/W",
                "StudyBranch": "",
                "Day": "26.07.",
                "StartTime": "14:00",
                "EndTime": "15:30",
                "Examiner": "G.Flach",
                "NextChance": "",
                "Rooms": [
                    "S 315",
                    "S 327"
                ]
            }
        ]
        """.data(using: .utf8)!

        let exams = try! JSONDecoder().decode([Exam].self, from: json)
        XCTAssertEqual(exams[0].title, "E012  Gerätekonstruktion / Werkstofftechnik")
        XCTAssertEqual(exams[1].examiners[0], "P.Sobe")
        XCTAssertEqual(exams[2].rooms[0], "S 315")
    }

    func testDateAndDuration() {
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())

        let exam1 = Exam(day: "21.07.", startTime: "15:30", endTime: "17:00")
        let components1 = DateComponents(year: currentYear, month: 7, day: 21, hour: 15, minute: 30)
        let date1 = Calendar(identifier: .gregorian).date(from: components1)
        XCTAssertEqual(exam1.date, date1)
        XCTAssertEqual(exam1.duration, 1.5 * 60 * 60)

        let exam2 = Exam(day: "08.02.", startTime: "7:30", endTime: "10:00")
        let components2 = DateComponents(year: currentYear, month: 2, day: 8, hour: 7, minute: 30)
        let date2 = Calendar(identifier: .gregorian).date(from: components2)
        XCTAssertEqual(exam2.date, date2)
        XCTAssertEqual(exam2.duration, 2.5 * 60 * 60)
    }

    static var allTests = [
        ("testDeserialization", testDeserialization),
        ("testDateAndDuration", testDateAndDuration)
    ]
}

extension Exam {
    init(day: String, startTime: String, endTime: String) {
        self.title = ""
        self.type = ""
        self.studyBranch = ""
        self.day = day
        self.startTime = startTime
        self.endTime = endTime
        self.examiners = []
        self.nextChance = ""
        self.rooms = []
    }
}
