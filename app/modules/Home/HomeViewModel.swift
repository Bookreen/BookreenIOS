import Foundation

struct Day {
    let date: Date
    let dayOfMonth: Int
    let dayOfWeek: Int
    let dayTitle: String
    let daySummary: String
    let isSelected: Bool
}

enum HomeViewOutput {
    case showLoading(Bool)
    case failureGetLocation
    case successGetLocation(SpaceModel)
    case loadedWeekDayList
    case fetchedBookingList
    case successSaveInstantBooking(String)
    case failureSaveInstantBooking(String)
    case failureExtend(String)
    case successExtend(String)
}

protocol HomeViewModelProtocol: AnyObject {
    var weekDayList: [Day] { get set }
    var bookingList: [BookingModel] { get set }
    var todayBookingList: [BookingModel] { get set }
    var delegate: HomeViewModelDelegate? { get set }
    func startBooking(_ booking: BookingModel)
    func endBooking(_ booking: BookingModel)
    func extendBooking(_ booking: BookingModel, extendTime: Int)
    func cancelBooking(_ booking: BookingModel)
    func getLocation(locationId: String)
    func createInstantBooking(space: SpaceModel, time: Int)
    func getWeekdays()
    func fetchBookingList()
    func hasExistsBooking(_ date: Date) -> Bool
    func getWeather(latitude: Double, longitude: Double)
}

protocol HomeViewModelDelegate: AnyObject {
    func handleOutput(_ output: HomeViewOutput)
}

final class HomeViewModel: HomeViewModelProtocol {

    var weekDayList: [Day]
    var bookingList: [BookingModel]
    var todayBookingList: [BookingModel]
    var delegate: HomeViewModelDelegate?
    private let bookreenService: BookreenServiceProtocol
    private let openWeatherMapService: OpenWeatherMapServiceProtocol
    
    init(bookreenService: BookreenServiceProtocol, openWeatherMapService: OpenWeatherMapServiceProtocol) {
        self.bookreenService = bookreenService
        self.openWeatherMapService = openWeatherMapService
        self.bookingList = []
        self.weekDayList = []
        self.todayBookingList = []
    }
    
    func getWeather(latitude: Double, longitude: Double) {
        let input = GetWeatherInput(latitude: latitude, longitude: longitude)
        self.openWeatherMapService.getWeather(input: input) { result in
            switch result {
            case .failure(_):
                print("not found weather data")
            case .success(let message, let weather):
                print(message)
                print(weather.name)
            }
        }
    }
    
    func getWeekdays() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = (calendar.component(.weekday, from: today) - 1)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        
        self.weekDayList.removeAll()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        for date in days {
            let dayOfMonth = Int(formatter.getDayOfMonth(date: date)) ?? 0
            let titleOfDay = formatter.getDayTitle(date: date)
            let summaryOfDay = formatter.getDaySummary(date: date)
            let weekDay = (calendar.component(.weekday, from: date) - 1) % 7
            let isSelected = Calendar.current.isDateInToday(date)
            let day = Day(date: date, dayOfMonth: dayOfMonth, dayOfWeek: (weekDay == 0) ? 7 : weekDay, dayTitle: titleOfDay, daySummary: summaryOfDay, isSelected: isSelected)
            self.weekDayList.append(day)
        }
        self.delegate?.handleOutput(.loadedWeekDayList)
    }
    
    func hasExistsBooking(_ date: Date) -> Bool {
        let filterResult = self.bookingList.filter { item in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let planDate = dateFormatter.date(from: item.planDate ?? "") {
                return planDate == date
            } else {
                return false
            }
        }
        return filterResult.count > 0
    }
    
    private func fetchBookingListByDate(_ date: Date) -> [BookingModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dS=dateFormatter.string(from: date)
        let filterResult = self.bookingList.filter { item in
            return item.planDate==dS
        }
        return filterResult.sorted { item1, item2 in
            return (item1.startTime ?? "") < (item2.startTime ?? "")
        }
    }
    
    func cancelBooking(_ booking: BookingModel) {
        let status = "cancel"
        let meetingPlanId = booking.id ?? ""
        let meetingRoomId = booking.spaceId ?? ""
        
        let input = SetReservationInput(status: status, meetingPlanId: meetingPlanId, meetingRoomId: meetingRoomId)
        self.bookreenService.setReservation(input: input) { result in
            self.fetchBookingList()
        }
    }
    
    func startBooking(_ booking: BookingModel) {
        let status = "checkin"
        let meetingPlanId = booking.id ?? ""
        let meetingRoomId = booking.spaceId ?? ""
        
        let input = SetReservationInput(status: status, meetingPlanId: meetingPlanId, meetingRoomId: meetingRoomId)
        self.bookreenService.setReservation(input: input) { result in
            self.fetchBookingList()
        }
    }
    
    func endBooking(_ booking: BookingModel) {
        let status = "checkout"
        let meetingPlanId = booking.id ?? ""
        let meetingRoomId = booking.spaceId ?? ""
        
        let input = SetReservationInput(status: status, meetingPlanId: meetingPlanId, meetingRoomId: meetingRoomId)
        self.bookreenService.setReservation(input: input) { result in
            self.fetchBookingList()
        }
    }
    
    func extendBooking(_ booking: BookingModel, extendTime: Int) {
        let meetingPlanId = booking.id ?? ""
        let input = ExtendMeetingPlanInput(meetingPlanId: meetingPlanId, minute: extendTime)
        self.bookreenService.extendMeetingPlan(input: input) { result in
            switch result{
            case .success(_, let res):
                if res?.status == true{
                    self.fetchBookingList()
                    self.delegate?.handleOutput(.successExtend(res?.message ?? ""))
                }else{
                    self.delegate?.handleOutput(.failureExtend(res?.message ?? ""))
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func getLocation(locationId: String) {
        let input = GetLocationInput(locationId: locationId)
        self.delegate?.handleOutput(.showLoading(true))
        self.bookreenService.getLocation(input: input) { result in
            self.delegate?.handleOutput(.showLoading(false))
            switch result {
            case .failure(_):
                self.delegate?.handleOutput(.failureGetLocation)
            case .success(_, let space):
                if let _space = space {
                    self.delegate?.handleOutput(.successGetLocation(_space))
                } else {
                    self.delegate?.handleOutput(.failureGetLocation)
                }
            }
        }
    }
    
    func createInstantBooking(space: SpaceModel, time: Int) {
        
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
        
        let hour = Calendar.current.component(.hour, from: date)
        let minutes = Calendar.current.component(.minute, from: date)

        let hourAsString = hour < 10 ? "0\(hour)" : "\(hour)"
        let minutesAsString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        
        let startTimeMinutes = (hour * 60) + minutes
        let endTimeTotalMinutes = startTimeMinutes + time
        
        let endTimeHour = endTimeTotalMinutes / 60
        let endTimeMinutes  = endTimeTotalMinutes % 60
        
        let endTimeHourAsString = endTimeHour < 10 ? "0\(endTimeHour)" : "\(endTimeHour)"
        let endTimeMinutesAsString = endTimeMinutes < 10 ? "0\(endTimeMinutes)" : "\(endTimeMinutes)"
        
        let startTime = "\(hourAsString):\(minutesAsString)"
        let endTime = "\(endTimeHourAsString):\(endTimeMinutesAsString)"
        let locationId = Int(space.id ?? "") ?? 0
        let locationName = space.name ?? ""
        let remind = 15
        
        let input = SaveOfficeReservationInput(
            subject: "Anlık Rezervasyon",
            color: "#2062af",
            planDate: planDate,
            sTime: startTime,
            eTime: endTime,
            isAllDay: 0,
            locationID: locationId,
            locationName: locationName,
            serviceOptions: nil,
            remind: remind,
            carparkLocationId: 0,
            lockerLocationId: 0
        )
        
        self.bookreenService.saveReservation(input: input) { result in
            switch result {
            case .success(_, let response):
                self.fetchBookingList()
                if response.reservationID != nil {
                    self.delegate?.handleOutput(.successSaveInstantBooking(response.message))
                } else {
                    self.delegate?.handleOutput(.failureSaveInstantBooking(response.message))
                }
            case .failure(_):
                self.delegate?.handleOutput(.failureSaveInstantBooking("Reservation could not be saved due to there you have reservation in same time"))
            }
        }
    }
    
    func fetchBookingList() {
        self.bookreenService.getAllEvents { result in
            switch result {
            case .success(_, let response):
                let ongoingEvents = response.ongoingEvents ?? []
                let checkinWaitingEvents = response.checkinWaitingEvents ?? []
                let upcomingEvents = response.upcomingEvents ?? []
                
                self.bookingList.removeAll()
                
                ongoingEvents.forEach { item in
                    item.bookingStatus = .ongoingEvents
                    self.bookingList.append(item)
                }
                
                checkinWaitingEvents.forEach { item in
                    item.bookingStatus = .checkinWaitingEvents
                    self.bookingList.append(item)
                }
                
                upcomingEvents.forEach { item in
                    item.bookingStatus = .upcomingEvents
                    self.bookingList.append(item)
                }
                
                self.todayBookingList = self.fetchBookingListByDate(Date())
                self.delegate?.handleOutput(.fetchedBookingList)
            case .failure(_):
                self.bookingList = []
                self.todayBookingList = []
                self.delegate?.handleOutput(.fetchedBookingList)
            }
        }
    }
}
