//
//  Date+Utilities.swift
//  Demo
//
//  Created by Marco Ghaly on 13/05/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import Foundation

extension Date {
    func format(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func get(component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func get(components: Set<Calendar.Component>, calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(components, from: self)
    }
    
    func add(component: Calendar.Component, value: Int, calendar: Calendar = Calendar.current) -> Date {
        return calendar.date(byAdding: component, value: value, to: self)!
    }
    
    func removeTime(calendar: Calendar = Calendar.current) -> Date {
        return calendar.date(from: get(components: [.year, .month, .day]))!
    }
    
    func startOfWeek(calendar: Calendar = Calendar.current) -> Date {
        calendar.date(from: get(components: [.yearForWeekOfYear, .weekOfYear]))!
    }
    
    func endOfWeek(calendar: Calendar = Calendar.current) -> Date {
        let startOfWeek = self.startOfWeek()
        return startOfWeek.add(component: .weekOfMonth, value: 1).add(component: .second, value: -1)
    }
    
    var weekDays: [Date] {
        var weekDays: [Date] = []
        let startOfWeek = self.startOfWeek()
        for offset in 0..<7 {
            let date = startOfWeek.add(component: .day, value: offset)
            weekDays.append(date)
        }
        return weekDays
    }
}
