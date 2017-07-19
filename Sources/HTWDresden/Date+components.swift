import Foundation

extension Date {
    init?(withDayString dayString: String, andTimeString timeString: String) {
        guard let date = Date(withDayString: dayString) else { return nil }

        let timeStringComponents = timeString.components(splitBy: ":")
        guard timeStringComponents.count == 2 else { return nil }
        let (hour, minute) = (timeStringComponents[0], timeStringComponents[1])

        self = date + TimeInterval(((hour * 60) + minute) * 60)
    }

    init?(withDayString dayString: String) {
        let components = dayString.components(splitBy: ".")
        guard components.count >= 2 else { return nil }
        let (day, month) = (components[0], components[1])
        let year: Int
        if components.count == 3 {
            year = components[2]
        } else {
            year = Calendar.current.component(.year, from: Date())
        }
        guard let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) else { return nil }
        self = date
    }

    init?(withShortISO isoString: String) {
        let components = isoString.components(splitBy: "-")
        guard components.count == 3 else { return nil }
        let (year, month, day) = (components[0], components[1], components[2])
        guard let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) else { return nil }
        self = date
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
