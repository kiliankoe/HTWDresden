import Foundation

extension Date {
    init?(withDayString dayString: String, andTimeString timeString: String) {
        let dayStringComponents = dayString.components(splitBy: ".")
        guard dayStringComponents.count > 1 else { return nil }

        let timeStringComponents = timeString.components(splitBy: ":")
        guard timeStringComponents.count == 2 else { return nil }

        let (day, month) = (dayStringComponents[0], dayStringComponents[1])
        let (hour, minute) = (timeStringComponents[0], timeStringComponents[1])

        let year: Int
        if dayStringComponents.count == 3 {
            year = dayStringComponents[2]
        } else {
            year = Date.currentYear
        }

        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        guard let date = Calendar.current.date(from: components) else { return nil }
        self = date
    }

    init?(withShortISO isoString: String) {
        let components = isoString.components(splitBy: "-")
        guard components.count == 3 else { return nil }
        let (year, month, day) = (components[0], components[1], components[2])
        guard let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) else { return nil }
        self = date
    }

    static var currentYear: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: Date())
    }

    func distance(toTimeString timeString: String) -> TimeInterval? {
        let timeStringComponents = timeString.components(splitBy: ":")
        guard timeStringComponents.count == 2 else { return nil }
        let (hour, minute) = (timeStringComponents[0], timeStringComponents[1])
        let selfComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: DateComponents(year: selfComponents.year, month: selfComponents.month, day: selfComponents.day, hour: hour, minute: minute))
        return date?.timeIntervalSince(self)
    }
}

extension String {
    func components(splitBy separator: Character) -> [Int] {
        return self
            .split(separator: separator)
            .map(String.init)
            .flatMap { Int($0) }
    }
}
