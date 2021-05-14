//
//  DateExtensionsTests.swift
//  DemoTests
//
//  Created by Marco Ghaly on 13/05/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import XCTest
@testable import Demo

class DateExtensionsTests: XCTestCase {
    private typealias Inputs = [Date]
    private typealias Outputs = (startOfWeek: Date, endOfWeek: Date)
    private typealias Result = (inputs: Inputs, outputs: Outputs)
    
    private static let dateFormat = "yyyy-MM-dd"
    private static let timeFormat = "HH:mm:ss"
    private static let dateTimeFormat = String(format: "%@'T'%@", dateFormat, timeFormat)
    
    private var results: [Result] {
        let results = [(inputs: ["2020-10-25", "2020-10-25T00:00:01", "2020-10-26", "2020-10-27", "2020-10-28", "2020-10-29", "2020-10-30", "2020-10-31", "2020-10-31T23:59:59"],
                        outputs: (startOfWeek: "2020-10-25", endOfWeek: "2020-10-31T23:59:59"))]
        
        return results.map {
            (inputs: $0.inputs.map { date($0) }, outputs: (startOfWeek: date($0.outputs.startOfWeek), endOfWeek: date($0.outputs.endOfWeek)))
        }
    }
    
    func testStartAndEndOfWeek() {
        results.forEach { inputs, outputs in
            inputs.forEach { input in
                XCTAssertEqual(input.startOfWeek(), outputs.startOfWeek)
                XCTAssertEqual(input.endOfWeek(), outputs.endOfWeek)
            }
        }
    }
    
    private func date(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateExtensionsTests.dateTimeFormat
        var date = dateFormatter.date(from: dateString)
        if date == nil {
            dateFormatter.dateFormat = DateExtensionsTests.dateFormat
            date = dateFormatter.date(from: dateString)
        }
        return date!
    }
}
