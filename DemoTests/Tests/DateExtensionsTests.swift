import XCTest
@testable import Demo

class DateExtensionsTests: XCTestCase {
    func testStartAndEndOfWeek() {
        Self.testCases.forEach { inputs, outputs in
            inputs.forEach { input in
                XCTAssertEqual(input.startOfWeek(calendar: Self.calendar), outputs.startOfWeek)
                XCTAssertEqual(input.endOfWeek(calendar: Self.calendar), outputs.endOfWeek)
            }
        }
    }
}

// MARK: - Helpers
private extension DateExtensionsTests {
    static func date(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .init(secondsFromGMT: 0)
        dateFormatter.dateFormat = DateExtensionsTests.dateTimeFormat
        var date = dateFormatter.date(from: dateString)
        if date == nil {
            dateFormatter.dateFormat = DateExtensionsTests.dateFormat
            date = dateFormatter.date(from: dateString)
        }
        return date!
    }
}

// MARK: - Test Cases
private extension DateExtensionsTests {
    typealias Inputs = [Date]
    typealias Outputs = (startOfWeek: Date, endOfWeek: Date)
    typealias TestCase = (inputs: Inputs, outputs: Outputs)
    
    static var testCases: [TestCase] {
        let testCases = [(
            inputs: [
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
            outputs: (
                startOfWeek: "2020-10-25",
                endOfWeek: "2020-10-31T23:59:59"
            )
        )]
        
        return testCases.map {
            (
                inputs: $0.inputs.map { date($0) },
                outputs: (
                    startOfWeek: date($0.outputs.startOfWeek),
                    endOfWeek: date($0.outputs.endOfWeek)
                )
            )
        }
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
