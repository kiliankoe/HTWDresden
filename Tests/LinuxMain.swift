import XCTest
@testable import HTWDresdenTests

XCTMain([
    testCase(DateTests.allTests),
    testCase(ExamTests.allTests),
    testCase(GradeTests.allTests),
    testCase(LessonTests.allTests),
    testCase(SemesterPlanTests.allTests),
    testCase(SemesterTests.allTests),
])
