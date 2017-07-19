import XCTest
@testable import HTWDresden

class LessonTests: XCTestCase {
    func testDeserialization() {
        let json = """
        [
            {
                "lessonTag": "Inf",
                "name": "Informatik 2",
                "type": "Ü",
                "week": 0,
                "day": 5,
                "beginTime": "09:20:00",
                "endTime": "10:50:00",
                "professor": "Wiedemann",
                "WeeksOnly": "",
                "Rooms": [
                    "S 130"
                ]
            },
                {
                "lessonTag": "Mathe",
                "name": "Mathematik 2",
                "type": "V",
                "week": 0,
                "day": 4,
                "beginTime": "11:10:00",
                "endTime": "12:40:00",
                "professor": "Jung",
                "WeeksOnly": "",
                "Rooms": [
                    "Z 211"
                ]
            },
            {
                "lessonTag": "EL",
                "name": "Elektronik 1",
                "type": "V",
                "week": 1,
                "day": 4,
                "beginTime": "13:20:00",
                "endTime": "14:50:00",
                "professor": "Kühn",
                "WeeksOnly": "",
                "Rooms": [
                    "Z 208"
                ]
            }
        ]
        """.data(using: .utf8)!

        let lessons = try! JSONDecoder().decode([Lesson].self, from: json)
        XCTAssertEqual(lessons[0].name, "Informatik 2")
        XCTAssertEqual(lessons[1].kind, .lecture)
        XCTAssertEqual(lessons[1].week, .even)
        XCTAssertEqual(lessons[1].day, .thursday)
        XCTAssertEqual(lessons[2].lecturer, "Kühn")
    }

    func testTimeInfo() {
        let lesson1 = Lesson(begin: "09:20:00", end: "10:50:00")
        XCTAssertEqual(lesson1.beginTime?.description, "9:20")
        XCTAssertEqual(lesson1.endTime?.description, "10:50")
        XCTAssertEqual(lesson1.timeSlot, 2)

        let lesson2 = Lesson(begin: "13:20:00", end: "14:50:00")
        XCTAssertEqual(lesson2.beginTime?.description, "13:20")
        XCTAssertEqual(lesson2.endTime?.description, "14:50")
        XCTAssertEqual(lesson2.timeSlot, 4)
    }

    static var allTests = [
        ("testDeserialization", testDeserialization),
        ("testTimeInfo", testTimeInfo)
    ]
}

extension Lesson {
    init(begin: String, end: String) {
        self.tag = ""
        self.name = ""
        self.kind = .lecture
        self.week = .even
        self.day = .monday
        self.begin = begin
        self.end = end
        self.lecturer = ""
        self.weeksOnly = ""
        self.rooms = []
    }
}
