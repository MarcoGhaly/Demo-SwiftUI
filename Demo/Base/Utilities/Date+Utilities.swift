import Foundation

extension Date {
    func format(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func get(
        component: Calendar.Component,
        calendar: Calendar = Calendar.current
    ) -> Int {
        calendar.component(component, from: self)
    }
    
    func get(
        components: Set<Calendar.Component>,
        calendar: Calendar = Calendar.current
    ) -> DateComponents {
        calendar.dateComponents(components, from: self)
    }
    
    func add(
        component: Calendar.Component,
        value: Int,
        calendar: Calendar = Calendar.current
    ) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
    
    func removeTime(calendar: Calendar = Calendar.current) -> Date {
        let components = get(components: [.year, .month, .day], calendar: calendar)
        return calendar.date(from: components)!
    }
}

extension Date {
    func startOfWeek(calendar: Calendar = Calendar.current) -> Date {
        calendar.date(from: get(components: [.yearForWeekOfYear, .weekOfYear], calendar: calendar))!
    }
    
    func endOfWeek(calendar: Calendar = Calendar.current) -> Date {
        let startOfWeek = self.startOfWeek(calendar: calendar)
        return startOfWeek
            .add(component: .weekOfMonth, value: 1, calendar: calendar)
            .add(component: .second, value: -1, calendar: calendar)
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
