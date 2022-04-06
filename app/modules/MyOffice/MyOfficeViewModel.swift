import Foundation

enum MyOfficeViewOutput {
    case showLoading(Bool)
    case successSaveMyOffice
    case failureSaveMyOffice
    case successGetCampusList
    case successGetBuildingList
    case successGetFloorList
    case handleError(Error)
}

protocol MyOfficeViewModelDelegate: AnyObject {
    func handleOutput(_ output: MyOfficeViewOutput)
}

protocol MyOfficeViewModelProtocol: AnyObject {
    var delegate: MyOfficeViewModelDelegate? { get set }
    var selectedCampus: CampusModel? { get set }
    var selectedBuilding: BuildingModel? { get set }
    var selectedFloor: FloorModel? { get set }
    var campusList: [CampusModel] { get set }
    var buildingList: [BuildingModel] { get set }
    var floorList: [FloorModel] { get set }
    func getCampusList()
    func getBuildingList(campusId: String)
    func getFloorList(buildingId: String)
    func saveMyOffice()
}

final class MyOfficeViewModel: MyOfficeViewModelProtocol {
    
    var delegate: MyOfficeViewModelDelegate?
    
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
                self.delegate?.handleOutput(.successGetFloorList)
            case .failure(_):
                self.floorList = []
                self.delegate?.handleOutput(.successGetFloorList)
            }
        }
    }
    
    func saveMyOffice() {
        let campusId = self.selectedCampus?.id ?? ""
        let buildingId = self.selectedBuilding?.id ?? ""
        let floorId = self.selectedFloor?.id ?? ""
        let campusName = self.selectedCampus?.name ?? ""
        let buildingName = self.selectedBuilding?.name ?? ""
        let floorName = self.selectedFloor?.name ?? ""
        
        if !campusId.isEmpty && !buildingId.isEmpty && !floorId.isEmpty {
            self.delegate?.handleOutput(.showLoading(true))
            let input = SaveMyOfficeInput(campusId: campusId, buildingId: buildingId, floorId: floorId)
            self.bookreenService.saveMyOffice(input: input) { result in
                self.delegate?.handleOutput(.showLoading(false))
                switch result {
                case .success(_, let output):
                    if output.status {
                        SessionManager.shared.campusId = campusId
                        SessionManager.shared.buildingId = buildingId
                        SessionManager.shared.floorId = floorId
                        SessionManager.shared.campusName = campusName
                        SessionManager.shared.buildingName = buildingName
                        SessionManager.shared.floorName = floorName
                        self.delegate?.handleOutput(.successSaveMyOffice)
                    } else {
                        self.delegate?.handleOutput(.failureSaveMyOffice)
                    }
                case .failure(_):
                    self.delegate?.handleOutput(.failureSaveMyOffice)
                }
            }
        }
    }
}
