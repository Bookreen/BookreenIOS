import Foundation
import Then

enum NewOfficeReservationViewOutput {
    case showLoading(Bool)
    case handleError(Error)
    case successSaveReservation(String)
    case failureSaveReservation(String)
    case onChangeDate
    case onChangeHour
    case onChangeEndHour
    case onChangeTimeView
    case onChangeTimeRangeType
    case onChangeColor
    case onChangeReminderMinutes
    case successGetAutoSpace
    case failureGetAutoSpace
    case loadedCompanyServiceOptions
}

enum TimeRangeType {
    case none
    case allDay
    case morning
    case afternoon
}

struct ReservationSpaceModel {
    let spaceId: String?
    let spaceName: String?
    let campusId: String?
    let campusName: String?
    let buildingId: String?
    let buildingName: String?
    let floorId: String?
    let floorName: String?
    
    func locationDescription()->String{
        let campusName = self.campusName ?? ""
        let buildingName = self.buildingName ?? ""
        let floorName = self.floorName ?? ""
        return "\(campusName), \(buildingName), \(floorName)"
    }
}

protocol NewOfficeReservationViewModelProtocol {
    var delegate: NewOfficeReservationViewModelDelegate? { get set }
    var date: DateFieldModel? { get set }
    var hour: HourFieldModel? { get set }
    var endHour:HourFieldModel? {get set}
    var companyServiceOptions: [GetCompanyServiceOptionsResponse] { get set }
    var selectedColor: String { get set }
    var timeRangeType: TimeRangeType { get set }
    var reminderMinutes: Int { get set }
    var selectedSpace: ReservationSpaceModel? { get set  }
    func getOfficeDays() -> [Int]
    func saveReservation(serviceOptions: [String:String])
    func getAutoSpace()
    func parseEndTime(_ totalMinutes: Int) -> String
    func getCompanyServiceOptions()
    func getAvailableCarParks()
    func getAvailableLockers()
}

protocol NewOfficeReservationViewModelDelegate {
    func handleOutput(_ output: NewOfficeReservationViewOutput)
}

final class NewOfficeReservationViewModel: NewOfficeReservationViewModelProtocol {
    
    var delegate: NewOfficeReservationViewModelDelegate?
    private let bookreenService: BookreenServiceProtocol
    
    var companyServiceOptions: [GetCompanyServiceOptionsResponse] {
        didSet {
            self.delegate?.handleOutput(.loadedCompanyServiceOptions)
        }
    }
    
    var selectedColor: String {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.handleOutput(.onChangeColor)
            }
        }
    }
    
    var hour: HourFieldModel? {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.handleOutput(.onChangeHour)
            }
        }
    }
    
    var endHour: HourFieldModel? {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.handleOutput(.onChangeEndHour)
            }
        }
    }
    var date: DateFieldModel? {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.handleOutput(.onChangeDate)
            }
        }
    }
    
    var timeRangeType: TimeRangeType {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.handleOutput(.onChangeTimeRangeType)
            }
        }
    }
    
    var reminderMinutes: Int {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.handleOutput(.onChangeReminderMinutes)
            }
        }
    }
    
    var selectedSpace: ReservationSpaceModel? {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.handleOutput(.successGetAutoSpace)
            }
        }
    }
    
    var id:String?
    
    init(bookreenService: BookreenServiceProtocol,booking:BookingModel?) {
        self.bookreenService = bookreenService
        id=booking?.id
        
        self.companyServiceOptions = []
        
        let calendar = Calendar.current
        let _date = calendar.date(byAdding: .day, value: 1, to: Date())!
        let day = calendar.component(.day, from: _date)
        
        let month  = calendar.component(.month, from: _date)
        let year = calendar.component(.year, from: _date)
        
        self.date = DateFieldModel(day: day < 10 ? "0\(day)" : "\(day)", month: month < 10 ? "0\(month)" : "\(month)", year: "\(year)")
        var splits=SessionManager.shared.workStartTime.split(separator: ":")
        if splits.count>1{
            self.hour=HourFieldModel(hour: String(splits[0]), minute: String(splits[1]))
        }else{
            self.hour = HourFieldModel(hour: "07", minute: "00")
        }
        splits=SessionManager.shared.workEndTime.split(separator: ":")
        if splits.count>1{
            self.endHour=HourFieldModel(hour: String(splits[0]), minute: String(splits[1]))
        }else{
            self.endHour=HourFieldModel(hour: "18", minute: "00")
        }
        self.timeRangeType = .allDay
        
        self.selectedColor = booking?.color ?? "#2062af"
        self.reminderMinutes = booking?.remindMintes ?? 15
        if let b=booking{
            if let start=b.startTime,let end=b.endTime,let date=b.planDate{
                setInitialDate(date: date, start: start,end: end)
                if start==SessionManager.shared.workStartTime{
                    if end==SessionManager.shared.lunchEndTime{
                        timeRangeType = .morning
                    }else if end==SessionManager.shared.workEndTime{
                        timeRangeType = .allDay
                    }else{
                        timeRangeType = .none
                    }
                }else if start==SessionManager.shared.lunchStartTime{
                    if end==SessionManager.shared.workEndTime{
                        timeRangeType = .afternoon
                    }else{
                        timeRangeType = .none
                    }
                }else{
                    timeRangeType = .none
                }
            }
        }else{
            checkOfficeDay(_date)
        }
    }
    
    //Check if initial date is not working. Then iterate over the next dates till we find a work day.
    private func checkOfficeDay(_ date:Date){
        var _date=date
        let calendar=Calendar.current
        var weekDay=calendar.component(.weekday, from: _date) - 1
        let officeDays=getOfficeDays()
        if !officeDays.contains(weekDay) && officeDays.count>0{
            while(true){
                _date = calendar.date(byAdding: .day, value: 1, to: _date)!
                weekDay=calendar.component(.weekday, from: _date) - 1
                if(officeDays.contains(weekDay)){
                    break
                }
            }
            let day = calendar.component(.day, from: _date)
            let month  = calendar.component(.month, from: _date)
            let year = calendar.component(.year, from: _date)
            self.date = DateFieldModel(day: day < 10 ? "0\(day)" : "\(day)", month: month < 10 ? "0\(month)" : "\(month)", year: "\(year)")
        }
    }
    
    private func setInitialDate(date:String,start:String,end:String){
        let formatter=DateFormatter().then {
            $0.dateFormat="yyyy-MM-dd HH:mm"
        }
        if let d=formatter.date(from: "\(date) \(start)"){
            let c=Calendar.current
            let components=c.dateComponents([.minute,.hour,.day,.month,.year], from: d)
            hour=HourFieldModel(hour: "\(components.hour!)", minute: "\(components.minute!)")
            self.date=DateFieldModel(day: "\(components.day!)", month: "\(components.month!)", year: "\(components.year!)")
        }
        if let e=formatter.date(from: "\(date) \(end)"){
            let c=Calendar.current
            let components=c.dateComponents([.minute,.hour,.day,.month,.year], from: e)
            endHour=HourFieldModel(hour: "\(components.hour!)", minute: "\(components.minute!)")
        }
    }
    
    
    private func getCompanyOfficeDays() -> [Int] {
        do {
            let officeDaysAsString = SessionManager.shared.officeDays
            if let _data = officeDaysAsString.data(using: .utf8) {
                let officeDaysAsInt = try JSONDecoder().decode([String].self, from: _data)
                return officeDaysAsInt.map { item in
                    return Int(item) ?? 0
                }
            }
            return []
        } catch {
            print(error)
            return []
        }
    }
    
    private func getDepartmentOfficeDays() -> [Int] {
        do {
            let officeDaysAsString = SessionManager.shared.departmentOfficeDays
            if let _data = officeDaysAsString.data(using: .utf8) {
                let officeDaysAsInt = try JSONDecoder().decode([String].self, from: _data)
                return officeDaysAsInt.map { item in
                    return Int(item) ?? 0
                }
            }
            return self.getCompanyOfficeDays()
        } catch {
            print(error)
            return self.getCompanyOfficeDays()
        }
    }
    
    func getOfficeDays() -> [Int] {
        let isEmptyDepartmentOfficeDays = SessionManager.shared.departmentOfficeDays.isEmpty
        if isEmptyDepartmentOfficeDays {
            return self.getCompanyOfficeDays()
        } else {
            return self.getDepartmentOfficeDays()
        }
    }
    
    func getAutoSpace() {
        let date = Date()
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        let yearString = yearFormatter.string(from: date)
        let monthString = monthFormatter.string(from: date)
        let dayString = dayFormatter.string(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let planDate = "\(yearString)-\(monthString)-\(dayString)"
        let startTime = SessionManager.shared.workStartTime
        let endTime = SessionManager.shared.workEndTime
        let locationType = "3"
        let input = GetAutoSpaceInput(locationType: locationType, planDate: planDate, sTime: startTime, eTime: endTime,capacity: 1)
        self.bookreenService.getAutoSpace(input: input) { result in
            switch result {
            case .failure(_):
                self.delegate?.handleOutput(.failureGetAutoSpace)
            case .success(_, let space):
                self.selectedSpace = ReservationSpaceModel(spaceId: space.id, spaceName: space.name, campusId: space.campusId, campusName: space.campusName, buildingId: space.buildingId, buildingName: space.buildingName, floorId: space.floorId, floorName: space.floorName)
            }
        }
    }
    
    func parseEndTime(_ totalMinutes: Int) -> String {
        let hour = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        let hourAsString = hour < 10 ? "0\(hour)" : "\(hour)"
        let minuteAsString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        return "\(hourAsString):\(minuteAsString)"
    }
    
    func getAvailableCarParks() {
        self.bookreenService.getAvailableCarParks(input: GetAvailableCarParksInput(planDate: "", sTime: "", eTime: "")) { result in
            switch result {
            case .success(_, _):
                print("success")
            case .failure(_):
                print("error")
            }
        }
    }
    
    func getAvailableLockers() {
        self.bookreenService.getAvailableLockers(input: GetAvailableLockersInput(planDate: "", sTime: "", eTime: "")) { result in
            switch result {
            case .success(_, _):
                print("success")
            case .failure(_):
                print("error")
            }
        }
    }
    
    func getCompanyServiceOptions() {
        self.bookreenService.getCompanyServiceOptions(input: GetCompanyServiceOptionsInput()) { result in
            switch result {
            case .success(_, let data):
                self.companyServiceOptions = data
            case .failure(_):
                self.companyServiceOptions = []
            }
        }
    }
    
    func saveReservation(serviceOptions: [String:String]) {
        guard let _date = self.date , let _end = endHour , let _hour = hour, let _space = selectedSpace else {
            return
        }
        
        let subject = S.tableReservation.localized()
        let planDate = "\(_date.year)-\(_date.month)-\(_date.day)"
        var startTime = ""
        var endTime = ""
        
        let locationID = Int(_space.spaceId ?? "0") ?? 0
        let locationName = _space.spaceName ?? ""
        
        let isAllDay = self.timeRangeType == .allDay ? 1 : 0
        
        if self.timeRangeType == .allDay {
            startTime = SessionManager.shared.workStartTime
            endTime = SessionManager.shared.workEndTime
        } else if self.timeRangeType == .morning {
            startTime = SessionManager.shared.workStartTime
            endTime = SessionManager.shared.lunchStartTime
        } else if self.timeRangeType == .afternoon {
            startTime = SessionManager.shared.lunchEndTime
            endTime = SessionManager.shared.workEndTime
        } else {
            startTime = "\(_hour.hour):\(_hour.minute)"
            endTime="\(_end.hour):\(_end.minute)"
        }
        
        if let id=self.id{
            update(id: id, subject: subject, date: planDate, start: startTime, end: endTime, allDay: isAllDay, location: locationID, locationName: locationName, serviceOptions: serviceOptions)
        }else{
            save(subject: subject, date: planDate, start: startTime, end: endTime, allDay: isAllDay, location: locationID, locationName: locationName, serviceOptions: serviceOptions)
        }
        
    }
    
    private func save(subject:String,date:String,start:String,
                      end:String,allDay:Int,location:Int,locationName:String,serviceOptions:[String:String]){
        let input = SaveOfficeReservationInput(
            subject: subject,
            color: self.selectedColor,
            planDate: date,
            sTime: start,
            eTime: end,
            isAllDay: allDay,
            locationID: location,
            locationName: locationName,
            serviceOptions:serviceOptions,
            remind: self.reminderMinutes,
            carparkLocationId: 0,
            lockerLocationId: 0
        )
        
        self.delegate?.handleOutput(.showLoading(true))
        self.bookreenService.saveReservation(input: input) { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .success(_, let response):
                if response.reservationID != nil {
                    self.delegate?.handleOutput(.successSaveReservation(response.message))
                } else {
                    self.delegate?.handleOutput(.failureSaveReservation(response.message))
                }
            case .failure(_):
                self.delegate?.handleOutput(.failureSaveReservation("Reservation could not be saved due to there you have reservation in same time"))
            }
        }
    }
    
    private func update(id:String,subject:String,date:String,start:String,
                        end:String,allDay:Int,location:Int,locationName:String,serviceOptions:[String:String]){
        let input = UpdateReservationInput(
            id:id,
            subject: subject,
            color: self.selectedColor,
            planDate: date,
            sTime: start,
            eTime: end,
            isAllDay: allDay,
            locationID: location,
            locationName: locationName,
            serviceOptions:serviceOptions,
            remind: self.reminderMinutes
        )
        
        self.delegate?.handleOutput(.showLoading(true))
        self.bookreenService.updateReservation(input: input) { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .success(_, let response):
                if response.reservationID != nil {
                    self.delegate?.handleOutput(.successSaveReservation(response.message))
                } else {
                    self.delegate?.handleOutput(.failureSaveReservation(response.message))
                }
            case .failure(_):
                self.delegate?.handleOutput(.failureSaveReservation("Reservation could not be saved due to there you have reservation in same time"))
            }
        }
    }
}
