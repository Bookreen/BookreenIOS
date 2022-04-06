import Foundation
import UIKit

struct CalendarBookingModel {
    let date: Date
    let dateAsString: String
    let bookingList: [BookingModel]
    var isSelected: Bool
}

enum CalendarViewOutput {
    case showLoading(Bool)
    case fetchedBookingList
    case updatedBookingList(IndexPath)
    case cancelFailed(String)
}

protocol CalendarViewModelProtocol: AnyObject {
    var delegate: CalendarViewModelDelegate? { get set }
    var calendarBookingList: [SpaceType:[CalendarBookingModel]] { get set }
    var allCalendarBookingList: [SpaceType:[CalendarBookingModel]] { get set }
    var selectedDate: Date? { get set }
    func fetchBookingList()
    func fetchBookingCountByDate(spaceType:SpaceType,_ date: Date) -> Int
    func fetchEventsOfThisMonth(spaceType:SpaceType,_ date: Date)
    func changeMonth(spaceType:SpaceType,_ date: Date)
    func selectBookingListByDate(spaceType:SpaceType,_ date: Date)
    func cancelBooking(_ booking:BookingModel)
}

protocol CalendarViewModelDelegate: AnyObject {
    func handleOutput(_ output: CalendarViewOutput)
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    var delegate: CalendarViewModelDelegate?
    var calendarBookingList: [SpaceType:[CalendarBookingModel]]
    var allCalendarBookingList: [SpaceType:[CalendarBookingModel]]
    var selectedDate: Date?
    
    private let bookreenService: BookreenServiceProtocol
    
    init(bookreenService: BookreenServiceProtocol) {
        self.bookreenService = bookreenService
        self.allCalendarBookingList = [.desk:[],.meeting:[]]
        self.calendarBookingList = [.desk:[],.meeting:[]]
    }
    
    private func beautyDate(_ date: Date) -> String {
        let formatter=DateFormatter()
        formatter.dateFormat="EEEE, dd MMM"
        return formatter.string(from: date)
    }
    
    func fetchBookingList() {
        self.bookreenService.getAllEvents { result in
            switch result {
            case .success(_, let response):
                let bookingList = response.upcomingEvents ?? []
                var desks=[BookingModel]()
                var meetings=[BookingModel]()
                bookingList.forEach { item in
                    if item.spaceTypeId == SpaceType.meeting.rawValue{
                        meetings.append(item)
                    }else{
                        desks.append(item)
                    }
                }
                self.fill(spaceType: .meeting, bookings: meetings)
                self.fill(spaceType: .desk, bookings: desks)
                self.fetchEventsOfThisMonth(spaceType: .desk ,self.selectedDate ?? Date())
                self.fetchEventsOfThisMonth(spaceType: .meeting ,self.selectedDate ?? Date())
                self.delegate?.handleOutput(.fetchedBookingList)
            case .failure(_):
                self.fetchEventsOfThisMonth(spaceType: .desk ,self.selectedDate ?? Date())
                self.fetchEventsOfThisMonth(spaceType: .meeting ,self.selectedDate ?? Date())
                self.delegate?.handleOutput(.fetchedBookingList)
            }
        }
    }
    
    private func fill(spaceType:SpaceType,bookings:[BookingModel]){
        let groupedBookingList = Dictionary(grouping: bookings) { item in
            return item.planDate ?? ""
        }
        let planDateFormatter = DateFormatter()
        planDateFormatter.dateFormat = "yyyy-MM-dd"
        var tempCalendarBookingList: [CalendarBookingModel] = []
        groupedBookingList.keys.forEach { key in
            let dateAsString = key
            
            if let date = planDateFormatter.date(from: dateAsString) {
                let tempBookingList = (groupedBookingList[key] ?? []).sorted { item1, item2 in
                    return (item1.startTime ?? "") < (item2.startTime ?? "")
                }
                let calendarBookingModel = CalendarBookingModel(date: date, dateAsString: self.beautyDate(date), bookingList: tempBookingList, isSelected: false)
                tempCalendarBookingList.append(calendarBookingModel)
            }
            
        }
        self.allCalendarBookingList[spaceType] = tempCalendarBookingList.sorted(by: { item1, item2 in
            return item1.date.compare(item2.date) == .orderedAscending
        })
    }
    
    func fetchBookingCountByDate(spaceType:SpaceType,_ date: Date) -> Int {
        let filter = self.calendarBookingList[spaceType]?.filter { item in
            return item.date == date
        }
        return filter?.count ?? 0
    }
    
    func changeMonth(spaceType:SpaceType, _ date: Date) {
        self.fetchEventsOfThisMonth(spaceType:spaceType,date)
        self.delegate?.handleOutput(.fetchedBookingList)
    }
    
    func fetchEventsOfThisMonth(spaceType:SpaceType, _ date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        let selectedMonth = components.month ?? -1
        print("==========================")
        print(selectedMonth)
        var tempCalendarBookingList: [CalendarBookingModel] = []
        
        self.allCalendarBookingList[spaceType]?.forEach { item in
            let itemComponents = calendar.dateComponents([.month], from: item.date)
            let itemMonth = itemComponents.month ?? -1
            print(itemMonth)
            if selectedMonth > -1 && itemMonth > -1 && selectedMonth == itemMonth {
                tempCalendarBookingList.append(item)
            }
        }
        print("==========================")
        self.calendarBookingList[spaceType] = tempCalendarBookingList
    }
    
    func selectBookingListByDate(spaceType:SpaceType,_ date: Date) {
        var tempCalendarBookingList: [CalendarBookingModel] = []
        var index = -1
        var selectedIndex = -1
        self.calendarBookingList[spaceType]?.forEach { item in
            index += 1
            let isSelected = item.date == date
            if isSelected {
                selectedIndex = index
            }
            let calendarBookingModel = CalendarBookingModel(date: item.date, dateAsString: item.dateAsString, bookingList: item.bookingList, isSelected: isSelected)
            tempCalendarBookingList.append(calendarBookingModel)
        }
        self.calendarBookingList[spaceType] = tempCalendarBookingList
        self.delegate?.handleOutput(.updatedBookingList(IndexPath(row: 0, section: selectedIndex > -1 ? selectedIndex : 0)))
    }
    
    func cancelBooking(_ booking: BookingModel) {
        let status = "cancel"
        let meetingPlanId = booking.id ?? ""
        let meetingRoomId = booking.spaceId ?? ""
        
        let input = SetReservationInput(status: status, meetingPlanId: meetingPlanId, meetingRoomId: meetingRoomId)
        self.bookreenService.setReservation(input: input) { result in
            switch result{
            case .success(_, let res):
                if res?.status != "1"{
                    self.delegate?.handleOutput(.cancelFailed(res?.textStatus ?? ""))
                }else{
                    self.fetchBookingList()
                }
            case .failure(let e):
                self.delegate?.handleOutput(.cancelFailed(e.localizedDescription))
            
        }
        }
    }
}
