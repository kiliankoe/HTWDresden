import Foundation

public struct Studygroup {
    public let year: Int
    public let courseID: Int
    public let group: Int
    public let degree: Degree

    var identifier: String {
        return "\(year)/\(courseID)/\(group)"
    }

    public init(year: Int, courseID: Int, group: Int, degree: Degree) {
        self.year = year
        self.courseID = courseID
        self.group = group
        self.degree = degree
    }
}

public enum Degree: String {
    case bachelor = "B"
    case master = "M"
    case diploma = "D"
}
