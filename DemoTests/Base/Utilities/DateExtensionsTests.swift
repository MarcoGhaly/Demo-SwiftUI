import Testing
import Foundation
@testable import Demo

struct DateExtensionsTests {
    @Test(
        arguments: [(
            [
                "2020-10-25",
                "2020-10-25T00:00:01",
                "2020-10-26",
                "2020-10-27",
                "2020-10-28",
                "2020-10-29",
                "2020-10-30",
                "2020-10-31",
                "2020-10-31T23:59:59"
            ],
            "2020-10-25",
            "2020-10-31T23:59:59"
        )]
    )
    func startAndEndOfWeek(dateStrings: [String], startOfWeekString: String, endOfWeekString: String) throws {
        try dateStrings.map {
            try #require(date($0))
        }.forEach { date in
            let startOfWeek = try #require(self.date(startOfWeekString))
            let endOfWeek = try #require(self.date(endOfWeekString))
            #expect(date.startOfWeek(calendar: Self.calendar) == startOfWeek)
            #expect(date.endOfWeek(calendar: Self.calendar) == endOfWeek)
        }
    }
}

// MARK: - Helpers
private extension DateExtensionsTests {
    func date(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .init(secondsFromGMT: .zero)
        dateFormatter.dateFormat = DateExtensionsTests.dateTimeFormat
        var date = dateFormatter.date(from: dateString)
        if date == nil {
            dateFormatter.dateFormat = DateExtensionsTests.dateFormat
            date = dateFormatter.date(from: dateString)
        }
        return date
    }
}

// MARK: - Constants
private extension DateExtensionsTests {
    private static let dateFormat = "yyyy-MM-dd"
    private static let timeFormat = "HH:mm:ss"
    private static let dateTimeFormat = String(format: "%@'T'%@", dateFormat, timeFormat)
    
    private static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        calendar.timeZone = .init(secondsFromGMT: 0)!
        return calendar
    }
}
