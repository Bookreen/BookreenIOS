import Foundation
import UIKit
import FSCalendar

struct DateFieldModel {
    let day: String
    let month: String
    let year: String
}

final class DatePickerViewController: AppViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var headerView: RadiusView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var officeDays: [Int] = []
    var callback: ((DateFieldModel) -> Void)?
    var date: Date?
    
    private let yesterday=Date().addingTimeInterval(-60*60*24)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelTitle.text = S.pleaseSelectDate.localized()
        self.calendarView.locale = Locale(identifier: Locale.current.identifier)
        self.calendarView.select(self.date)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.calendarView.delegate = nil
        self.calendarView.dataSource = nil
    }
    
    @IBAction func pressedButtonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DatePickerViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date < yesterday{
            return false
        }
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.component(.weekday, from: date)
        let currentDayOfWeek = components-1
        return officeDays.contains(currentDayOfWeek)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        let yearString = yearFormatter.string(from: date)
        let monthString = monthFormatter.string(from: date)
        let dayString = dayFormatter.string(from: date)
        
        let dateFieldModel = DateFieldModel(day: dayString, month: monthString, year: yearString)
        self.dismiss(animated: true) {
            self.callback?(dateFieldModel)
        }
    }
}

extension DatePickerViewController: FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
