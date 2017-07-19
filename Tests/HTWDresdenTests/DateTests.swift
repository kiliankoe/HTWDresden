import XCTest
@testable import HTWDresden

class DateTests: XCTestCase {
    func testDayString() {
        let date1 = Date(withDayString: "13.05.")
        XCTAssertEqual(date1?.comp.day, 13)
        XCTAssertEqual(date1?.comp.month, 5)

        let date2 = Date(withDayString: "17.07.2016")
        XCTAssertEqual(date2?.comp.day, 17)
        XCTAssertEqual(date2?.comp.month, 7)
        XCTAssertEqual(date2?.comp.year, 2016)

        let date3 = Date(withDayString: "05.")
        XCTAssertNil(date3)

        let date4 = Date(withDayString: "31.02.1999")
        XCTAssertEqual(date4?.comp.day, 3)
        XCTAssertEqual(date4?.comp.month, 3)
        XCTAssertEqual(date4?.comp.year, 1999)
    }

    func testDayAndTimeString() {
        let date1 = Date(withDayString: "26.08.", andTimeString: "9:00")
        XCTAssertEqual(date1?.comp.day, 26)
        XCTAssertEqual(date1?.comp.month, 8)
        XCTAssertEqual(date1?.comp.hour, 9)
        XCTAssertEqual(date1?.comp.minute, 0)

        let date2 = Date(withDayString: "01.05.2017", andTimeString: "18:35:50")
        XCTAssertEqual(date2?.comp.day, 1)
        XCTAssertEqual(date2?.comp.month, 5)
        XCTAssertEqual(date2?.comp.year, 2017)
        XCTAssertEqual(date2?.comp.hour, 18)
        XCTAssertEqual(date2?.comp.minute, 35)
        XCTAssertEqual(date2?.comp.second, 50)

        let date3 = Date(withDayString: "19.07.", andTimeString: "7")
        XCTAssertNil(date3)
    }

    func testISOShort() {
        let date1 = Date(withShortISO: "2017-07-22")
        XCTAssertEqual(date1?.comp.year, 2017)
        XCTAssertEqual(date1?.comp.month, 7)
        XCTAssertEqual(date1?.comp.day, 22)

        let date2 = Date(withShortISO: "04.09.2017")
        XCTAssertNil(date2)
    }

    func testDistanceToTimeString() {
        let origin = Date(withDayString: "19.07.2017", andTimeString: "18:43")
        XCTAssertEqual(origin?.distance(toTimeString: "19:00"), 1_020)
        XCTAssertEqual(origin?.distance(toTimeString: "21:30"), 10_020)
        XCTAssertEqual(origin?.distance(toTimeString: "00:00"), -67_380)
    }

    static var allTests = [
        ("testDayString", testDayString),
        ("testDayAndTimeString", testDayAndTimeString),
        ("testISOShort", testISOShort),
        ("testDistanceToTimeString", testDistanceToTimeString)
    ]
}

extension Date {
    var comp: DateComponents {
        return Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    }
}
