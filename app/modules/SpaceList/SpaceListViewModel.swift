import Foundation

struct SpaceListViewPresenter {
    let planDate: String
    let startTime: String
    let endTime: String
    let selectedSpace: ReservationSpaceModel?
}

enum SpaceListViewOutput {
    case loadedSpaceGroupList
}

protocol SpaceListViewModelProtocol: AnyObject {
    var selectedTag: Int { get set }
    var delegate: SpaceListViewModelDelegate? { get set }
    var spaceGroups: [SearchBookingResponse] { get set }
    var filterSpaceGroups: [SearchBookingResponse] { get set }
    var presenter: SpaceListViewPresenter { get set }
    var layoutId: Int { get set }
    var spaceType:SpaceType {get set}
    func searchBooking()
    func removeFavorite(space: SpaceModel)
    func addFavorite(space: SpaceModel)
}

protocol SpaceListViewModelDelegate: AnyObject {
    func handleOutput(_ output: SpaceListViewOutput)
}

final class SpaceListViewModel: SpaceListViewModelProtocol {
    
    var selectedTag: Int = 1 {
        didSet {
            self.filterSpaceGroupListFunc()
            self.delegate?.handleOutput(.loadedSpaceGroupList)
        }
    }
    
    var layoutId: Int = 0 {
        didSet {
            self.filterSpaceGroupListFunc()
            self.delegate?.handleOutput(.loadedSpaceGroupList)
        }
    }
    
    var delegate: SpaceListViewModelDelegate?
    var spaceGroups: [SearchBookingResponse]
    var filterSpaceGroups: [SearchBookingResponse]
    var presenter: SpaceListViewPresenter
    var spaceType: SpaceType
    private let bookreenService: BookreenServiceProtocol
    
    init(bookreenService: BookreenServiceProtocol, presenter: SpaceListViewPresenter,spaceType:SpaceType) {
        self.bookreenService = bookreenService
        self.selectedTag = 1
        self.spaceGroups = []
        self.filterSpaceGroups = []
        self.presenter = presenter
        self.spaceType=spaceType
    }
    
    func searchBooking() {
        let selectedSpace = self.presenter.selectedSpace
        let planDate = self.presenter.planDate
        let startTime = self.presenter.startTime
        let endTime = self.presenter.endTime
        
        let campusId = selectedSpace?.campusId ?? ""
        let buildingId = selectedSpace?.buildingId ?? ""
        let floorId = selectedSpace?.floorId ?? ""
        
        let office = SearchBookingOfficeInput(campusID: campusId, buildingID: buildingId, floorID: floorId)
        let input = SearchBookingInput(
            isInDepartment: false,
            office: office,
            locationType: spaceType.rawValue,
            layoutID: "0",
            equipmentIDs: [],
            capacity: "0",
            planDate: planDate,
            sTime: startTime,
            eTime: endTime
        )
        self.bookreenService.searchBooking(input: input) { result in
            switch result {
            case .failure(_):
                self.spaceGroups = []
                self.filterSpaceGroupListFunc()
            case .success(_, let response):
                self.spaceGroups = response.sorted(by: { item1, item2 in
                    return Int(item1.groupID ?? "0") ?? 0 < Int(item2.groupID ?? "0") ?? 0
                })
                self.filterSpaceGroupListFunc()
            }
            self.delegate?.handleOutput(.loadedSpaceGroupList)
        }
    }
    
    private func filterSpaceGroupListFunc() {
        if self.selectedTag == 1 {
            self.filterSpaceGroups.removeAll()
            self.spaceGroups.forEach { item in
                
                let filterResult = (item.occasions ?? []).filter { item in
                    if self.layoutId <= 0 {
                        return true
                    } else {
                        let itemLayoutId = Int(item.layout ?? "0") ?? 0
                        return self.layoutId == itemLayoutId
                    }
                }
                
                let occasions = filterResult.sorted { item1, item2 in
                    return (item1.id ?? "") < (item2.id ?? "")
                }
                let groupID = item.groupID
                let groupName = item.groupName
                let groupLink = item.groupLink
                if !filterResult.isEmpty {
                    self.filterSpaceGroups.append(SearchBookingResponse(groupID: groupID, groupName: groupName, groupLink: groupLink, occasions: occasions))
                }
            }
        } else if self.selectedTag == 2 { // en son
            self.filterSpaceGroups.removeAll()
            self.spaceGroups.forEach { item in
                let filterResult = (item.occasions ?? []).filter { item in
                    if self.layoutId <= 0 {
                        return (item.isRecently ?? "false") == "true"
                    } else {
                        let itemLayoutId = Int(item.layout ?? "0") ?? 0
                        return (item.isRecently ?? "false") == "true" && (self.layoutId == itemLayoutId)
                    }
                    
                }
                let groupID = item.groupID
                let groupName = item.groupName
                let groupLink = item.groupLink
                if !filterResult.isEmpty {
                    self.filterSpaceGroups.append(SearchBookingResponse(groupID: groupID, groupName: groupName, groupLink: groupLink, occasions: filterResult))
                }
            }
        } else if self.selectedTag == 3 { // sık
            self.filterSpaceGroups.removeAll()
            self.spaceGroups.forEach { item in
                let filterResult = (item.occasions ?? []).filter { item in
                    if self.layoutId <= 0 {
                        return (item.isMostly ?? "false") == "true"
                    } else {
                        let itemLayoutId = Int(item.layout ?? "0") ?? 0
                        return (item.isMostly ?? "false") == "true" && (self.layoutId == itemLayoutId)
                    }
                }
                let groupID = item.groupID
                let groupName = item.groupName
                let groupLink = item.groupLink
                if !filterResult.isEmpty {
                    self.filterSpaceGroups.append(SearchBookingResponse(groupID: groupID, groupName: groupName, groupLink: groupLink, occasions: filterResult))
                }
            }
        } else if self.selectedTag == 4 { // favoriler
            self.filterSpaceGroups.removeAll()
            self.spaceGroups.forEach { item in
                let filterResult = (item.occasions ?? []).filter { item in
                    if self.layoutId <= 0 {
                        return (item.isMyFavorite ?? "false") == "true"
                    } else {
                        let itemLayoutId = Int(item.layout ?? "0") ?? 0
                        return (item.isMyFavorite ?? "false") == "true" && (self.layoutId == itemLayoutId)
                    }
                }
                let groupID = item.groupID
                let groupName = item.groupName
                let groupLink = item.groupLink
                if !filterResult.isEmpty {
                    self.filterSpaceGroups.append(SearchBookingResponse(groupID: groupID, groupName: groupName, groupLink: groupLink, occasions: filterResult))
                }
            }
        }
    }
    
    func removeFavorite(space: SpaceModel) {
        let roomId = Int(space.id ?? "0") ?? 0
        let input = RemoveFavoriteInput(roomId: roomId)
        self.bookreenService.removeFavorite(input: input) { result in
            switch result {
            case .failure(_):
                self.searchBooking()
            case .success(_, _):
                self.searchBooking()
            }
        }
    }
    
    func addFavorite(space: SpaceModel) {
        let roomId = Int(space.id ?? "0") ?? 0
        let input = AddFavoriteInput(roomId: roomId)
        self.bookreenService.addFavorite(input: input) { result in
            switch result {
            case .failure(_):
                self.searchBooking()
            case .success(_, _):
                self.searchBooking()
            }
        }
    }
}
