import Foundation

extension DateFormatter {
    
    func getDayOfMonth(date: Date) -> String {
        self.dateFormat = "dd"
        return self.string(from: date)
    }
    
    func getDayTitle(date: Date) -> String {
        self.dateFormat = "EEEE"
        return self.string(from: date)
    }
    
    func getDaySummary(date: Date) -> String {
        self.dateFormat = "EEEEEE"
        return self.string(from: date)
    }
}
