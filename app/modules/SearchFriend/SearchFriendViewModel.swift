import Foundation

enum SearchFriendViewOutput {
    case showLoading(Bool)
    case handleError(Error)
    case successFetchedParticipantList
    case successFetchedBookingList
}

protocol SearchFriendViewModelProtocol: AnyObject {
    var delegate: SearchFriendViewModelDelegate? { get set }
    var participantList: [ParticipantModel] { get set}
    var bookingList: [BookingModel] { get set }
    func searchFriend(searchText: String)
    func searchBookingByEmail(email: String)
    func clearFriend()
}

protocol SearchFriendViewModelDelegate: AnyObject {
    func handleOutput(_ output: SearchFriendViewOutput)
}

class SearchFriendViewModel: SearchFriendViewModelProtocol {
    
    var delegate: SearchFriendViewModelDelegate?
    var participantList: [ParticipantModel]
    var bookingList: [BookingModel]
    
    private let bookreenService: BookreenServiceProtocol
    init(bookreenService: BookreenServiceProtocol) {
        self.bookreenService = bookreenService
        self.participantList = []
        self.bookingList = []
    }
    
    func clearFriend() {
        self.participantList = []
        self.delegate?.handleOutput(.successFetchedParticipantList)
    }
    
    func searchFriend(searchText: String) {
        let input = SearchParticipantInput(searchText: searchText)
        self.bookreenService.searchParticipant(input: input) { result in
            switch result {
            case .success(_, let participants):
                self.participantList = participants
                self.delegate?.handleOutput(.successFetchedParticipantList)
            case .failure(_):
                self.participantList = []
                self.delegate?.handleOutput(.successFetchedParticipantList)
            }
        }
    }
    
    func searchBookingByEmail(email: String) {
        let input = SearchBookingByEmailInput(email: email)
        self.bookreenService.searchBookingByEmail(input: input) { result in
            switch result {
            case .success(_, let bookingList):
                let tempBookingList = bookingList.filter({ item in
                    if let planDate = (item.planDate ?? "").convertDate(format: "YYYY-MM-dd") {
                        let diff = self.diffFromToday(planDate)
                        return diff >= 0
                    } else {
                        return false
                    }
                })
                if tempBookingList.count > 0 {
                    self.bookingList = [tempBookingList[0]]
                } else {
                    self.bookingList = []
                }
                
                self.delegate?.handleOutput(.successFetchedBookingList)
            case .failure(_):
                self.bookingList = []
                self.delegate?.handleOutput(.successFetchedBookingList)
            }
        }
    }
    
    func diffFromToday(_ date: Date) -> Int {
        let diffs = Calendar.current.dateComponents([.day], from: Date(), to: date)
        return diffs.day ?? -1
    }
}
