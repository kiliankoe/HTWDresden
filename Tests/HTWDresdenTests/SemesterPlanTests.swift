import XCTest
@testable import HTWDresden

class SemesterPlanTests: XCTestCase {
    func testDeserialization() {
        let json = """
        [
            {
                "year": 2015,
                "type": "W",
                "period": {
                    "beginDay": "2015-09-01",
                    "endDay": "2016-02-28"
                },
                "freeDays": [
                {
                    "name": "Reformationstag",
                    "beginDay": "2015-10-31",
                    "endDay": "2015-10-31"
                },
                {
                    "name": "Buß- und Bettag",
                    "beginDay": "2015-11-18",
                    "endDay": "2015-11-18"
                },
                {
                    "name": "Weihnachten/Jahreswechsel",
                    "beginDay": "2015-12-21",
                    "endDay": "2016-01-02"
                }
                ],
                "lecturePeriod": {
                    "beginDay": "2015-10-05",
                    "endDay": "2016-01-10"
                },
                "examsPeriod": {
                    "beginDay": "2016-02-01",
                    "endDay": "2016-02-20"
                },
                "reregistration": {
                    "beginDay": "2016-01-25",
                    "endDay": "2016-02-20"
                }
            }
        ]
        """.data(using: .utf8)!

        let plans = try! JSONDecoder().decode([SemesterPlan].self, from: json)
        XCTAssertEqual(plans[0].year, 2015)
        XCTAssertEqual(plans[0].kind, .winter)
        XCTAssertEqual(plans[0].period.begin.description, "2015-08-31 22:00:00 +0000")
        XCTAssertEqual(plans[0].freeDays[2].name, "Weihnachten/Jahreswechsel")
    }

    static var allTests = [
        ("testDeserialization", testDeserialization)
    ]
}
