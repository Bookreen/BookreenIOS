import Foundation


struct SelectFloorResult {
    let campusName: String
    let campusId: String
    let buildingName: String
    let buildingId: String
    let floorName: String
    let floorId: String
}

enum SelectFloorCallback {
    case selectedFloor(SelectFloorResult)
    case dismiss
}

enum SelectFloorViewOutput {
    case showLoading(Bool)
    case successGetCampusList
    case successGetBuildingList
    case successGetFloorList
    case handleError(Error)
}

protocol SelectFloorViewModelDelegate: AnyObject {
    func handleOutput(_ output: SelectFloorViewOutput)
}

protocol SelectFloorViewModelProtocol: AnyObject {
    var delegate: SelectFloorViewModelDelegate? { get set }
    var selectedCampus: CampusModel? { get set }
    var selectedBuilding: BuildingModel? { get set }
    var selectedFloor: FloorModel? { get set }
    var campusList: [CampusModel] { get set }
    var buildingList: [BuildingModel] { get set }
    var floorList: [FloorModel] { get set }
    func getCampusList()
    func getBuildingList(campusId: String)
    func getFloorList(buildingId: String)
}

final class SelectFloorViewModel: SelectFloorViewModelProtocol {
    
    var delegate: SelectFloorViewModelDelegate?
    var selectedCampus: CampusModel? = nil {
        didSet {
            let campusId = self.selectedCampus?.id ?? ""
            self.getBuildingList(campusId: campusId)
            self.selectedBuilding = nil
        }
    }
    
    var selectedBuilding: BuildingModel? = nil {
        didSet {
            let buildingId = self.selectedBuilding?.id ?? ""
            self.getFloorList(buildingId: buildingId)
            self.selectedFloor = nil
        }
    }
    var selectedFloor: FloorModel? = nil
    var campusList: [CampusModel]
    var buildingList: [BuildingModel]
    var floorList: [FloorModel]
    
    private let bookreenService: BookreenServiceProtocol
    
    init(bookreenService: BookreenServiceProtocol) {
        self.bookreenService = bookreenService
        self.campusList = []
        self.buildingList = []
        self.floorList = []
    }
    
    func getCampusList() {
        self.bookreenService.getCampusList { result in
            switch result {
            case .success(_, let _campusList):
                self.campusList = _campusList
                self.delegate?.handleOutput(.successGetCampusList)
            case .failure(_):
                self.campusList = []
                self.delegate?.handleOutput(.successGetCampusList)
            }
        }
    }
    
    func getBuildingList(campusId: String) {
        self.buildingList = []
        let input = GetBuildingListInput(campusId: campusId)
        self.bookreenService.getBuildingList(input: input) { result in
            switch result {
            case .success(_, let _buildingList):
                self.buildingList = _buildingList
                self.buildingList.forEach { item in
                    if item.id == SessionManager.shared.campusId {
                        self.selectedBuilding = item
                    }
                }
                self.delegate?.handleOutput(.successGetBuildingList)
            case .failure(_):
                self.buildingList = []
                self.delegate?.handleOutput(.successGetBuildingList)
            }
        }
    }
    
    func getFloorList(buildingId: String) {
        self.floorList = []
        let input = GetFloorListInput(buildingId: buildingId)
        self.bookreenService.getFloorList(input: input) { result in
            switch result {
            case .success(_, let _floorList):
                self.floorList = _floorList
                self.floorList.forEach { item in
                    if item.id == SessionManager.shared.campusId {
                        self.selectedFloor = item
                    }
                }
                self.delegate?.handleOutput(.successGetFloorList)
            case .failure(_):
                self.floorList = []
                self.delegate?.handleOutput(.successGetFloorList)
            }
        }
    }
}
