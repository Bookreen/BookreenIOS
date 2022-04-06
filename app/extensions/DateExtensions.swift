import Foundation

public extension Date {

    func beautyDate(format: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = format
        return dateFormatterGet.string(from: self)
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
